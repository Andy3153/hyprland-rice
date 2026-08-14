-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- functions.lua by Andy3153
-- created   06/08/26 ~ 19:15:03
--

-- {{{ Variables
local runtimeDir = os.getenv("XDG_RUNTIME_DIR")
local cacheDir   = os.getenv("XDG_CACHE_HOME")

local col = vars.color
local rgb = col.toRgb
-- }}}

-- {{{ Inspect table
local function inspectTable(t, indent, visited)
  indent  = indent or 0
  visited = visited or {}

  if type(t) ~= "table" then return tostring(t) end

  if visited[t] then return "[circular reference]" end

  visited[t] = true

  local result     = "{\n"
  local indent_str = string.rep("  ", indent + 1)

  for k, v in pairs(t) do
    local key_str = type(k) == "string" and '"' .. k .. '"' or k
    local val_str = inspectTable(v, indent + 1, visited)

    result = result .. indent_str .. key_str .. " = " .. val_str .. ",\n"
  end

  result = result .. string.rep("  ", indent) .. "}"

  return result
end
-- }}}

-- {{{ Print to Hyprland notifications
--
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Notifications/
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Using-hyprctl/#notify
--

function Print(text)
  text             = inspectTable(text)
  local timeout    = string.len(text) * 1000
  local maxTimeout = 20000

  if timeout > maxTimeout then timeout = maxTimeout end

  hl.notification.create(
  {
    text      = text,
    timeout   = timeout,
    icon      = 1,
    color     = rgb(col.select0),
    font_size = 14
  })
end

function PrintHyprland(text) Print(text) end
-- }}}

-- {{{ Print to OSD
function PrintOSD(table)
  local run = "swayosd-client "

  if table.icon then run = run .. "--custom-icon \"" .. table.icon .. "\" " end
  run = run .. "--custom-message \"" .. table.message .. "\""

  hl.exec_cmd(run)
end
-- }}}

-- {{{ Print to file
function PrintFile(arg)
  local filePath
  local message

  if type(arg) == "table" then
    message = arg.message

    if arg.file then
      filePath = cacheDir .. "/hyprlandRice." .. arg.file .. ".tmp"
    else
      filePath = cacheDir .. "/hyprlandRice.PrintFile.tmp"
    end

  else
    filePath = cacheDir .. "/hyprlandRice.PrintFile.tmp"
    message = arg
  end

  local file = io.open(filePath, "w")

  if file then
    file:write(message)
    file:close()
  end

  PrintHyprland("Wrote to file `" .. filePath .. "`")
end
-- }}}

-- {{{ Generate random string
function RandomString(stringLength)
  local charset = "abcdefghijklmnopqrstuvwxyz"
  local result = ""

  for i = 1, stringLength do
    local randIndex = math.random(1, #charset)
    result = result .. charset:sub(randIndex, randIndex)
  end

  return result
end
-- }}}

-- {{{ Systemd inhibit
function SystemdInhibitStart(table)
  if not table then table = { } end

  local run = "systemd-inhibit "
  local exec
  local pidFileName

  if table.mode then run = run .. "--mode \"" .. table.mode .. "\" " end
  if table.what then run = run .. "--what \"" .. table.what .. "\" " end
  if table.who  then run = run .. "--who \""  .. table.who  .. "\" " end
  if table.why  then run = run .. "--why \""  .. table.why  .. "\" " end

  if table.exec then
    exec = table.exec
  else
    exec = "sleep infinity"
  end

  run = run .. exec

  if table.pidFileName then
    pidFileName = table.pidFileName
  elseif table.what then
    pidFileName = table.what
  else
    pidFileName = RandomString(6)
  end

  run = run .. " & echo \"$!\" > \"" .. runtimeDir .. "/hyprlandRice." .. pidFileName .. ".pid\""

  if table.dontRun then return run else hl.exec_cmd(run) end
end

function SystemdInhibitStop(table)
  local pidFileName = table.pidFileName

  local pidFilePath = "\"" .. runtimeDir .. "/hyprlandRice." .. pidFileName .. ".pid" .. "\""

  local run = "kill -9 $(cat " .. pidFilePath .. ") || true && rm -f " .. pidFilePath

  if table.dontRun then return run else hl.exec_cmd(run) end
end
-- }}}

-- {{{ Lid switch behavior
local inhibitLidSwitchStart = SystemdInhibitStart(
{
  what        = "handle-lid-switch",
  who         = "Hyprland Rice",
  why         = "Inhibit lid switch (managed by Hyprland config)",
  pidFileName = "inhibitLidSwitch",
  dontRun     = true
})

local inhibitLidSwitchStop = SystemdInhibitStop(
{
  pidFileName = "inhibitLidSwitch",
  dontRun     = true
})

local inhibitLidSwitchStopStart = inhibitLidSwitchStop .. " ; " .. inhibitLidSwitchStart

local lidSwitchBehaviorIndex = 1

function LidSwitchBehaviorToggle()
  local icon
  local behaviorList = { "suspend", "lock", "ignore" }
  local index        = lidSwitchBehaviorIndex

  index                  = (index % #behaviorList) + 1
  lidSwitchBehaviorIndex = index

  local behavior = behaviorList[index]

  if behavior == "suspend" then
    icon = "system-suspend-symbolic"

    hl.unbind("switch:on:Lid Switch")
    hl.unbind("switch:off:Lid Switch")

    hl.exec_cmd(inhibitLidSwitchStop)

    -- managed by logind (https://github.com/Andy3153/nixos-rice/blob/c79f352ae24f9060090d25a0ce0f8a5ee100a521/modules/hardware/systemKeys.nix)

  elseif behavior == "lock" then
    icon = "lock-symbolic"

    hl.unbind("switch:on:Lid Switch")
    hl.unbind("switch:off:Lid Switch")

    hl.exec_cmd(inhibitLidSwitchStopStart)

    hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd(vars.action.lockScreen), { locked = true })

  elseif behavior == "ignore" then
    icon = "window-close-symbolic"

    hl.unbind("switch:on:Lid Switch")
    hl.unbind("switch:off:Lid Switch")

    hl.exec_cmd(inhibitLidSwitchStopStart)
  end

  PrintOSD(
  {
    icon    = icon,
    message = "Laptop lid behavior: " .. behavior
  })
end
-- }}}

-- {{{ Do not Disturb
function DndToggle()
  local icon

  local isDnd
  local dndOn  = "dunstctl set-paused true"
  local dndOff = "dunstctl set-paused false"

  local handle = io.popen("dunstctl is-paused")

  if handle ~= nil then
    isDnd = handle:read("*l")
    handle:close()
  end

  if isDnd == "true" then
    icon  = "notification-symbolic"
    isDnd = true
  else
    icon  = "notification-disabled-symbolic"
    isDnd = false
  end

  if isDnd then
    hl.exec_cmd(dndOff)

    PrintOSD(
    {
      icon    = icon,
      message = "Do not Disturb: off"
    })

  else
    hl.exec_cmd(dndOn)

    PrintOSD(
    {
      icon    = icon,
      message = "Do not Disturb: on"
    })
  end
end
-- }}}

-- {{{ Idle inhibit
function IdleInhibitToggle()
  local icon

  local pidFileName = "inhibitIdle"
  local pidFilePath = runtimeDir .. "/hyprlandRice." .. pidFileName .. ".pid"
  local pidFile     = io.open(pidFilePath, "r")

  if pidFile then
    icon = "my-caffeine-off-symbolic"

    pidFile:close()
    SystemdInhibitStop({ pidFileName = pidFileName })

    PrintOSD(
    {
      icon    = icon,
      message = "Idle inhibition: off"
    })

  else
    icon = "my-caffeine-on-symbolic"

    SystemdInhibitStart(
    {
      what        = "idle",
      who         = "Hyprland Rice",
      why         = "Inhibit idle (managed by Hyprland config)",
      pidFileName = pidFileName
    })

    PrintOSD(
    {
      icon    = icon,
      message = "Idle inhibition: on"
    })
  end
end
-- }}}

-- {{{ Screenshot
function Screenshot(table)
  if not table then table = { } end

  local run           = "flameshot "
  local activeMonitor = hl.get_active_monitor().id

  if table.mode then
    if table.mode == "allScreens" then run = run .. "full " end
    if table.mode == "screen"     then run = run .. "screen " .. "--number " .. activeMonitor .. " " end
    if table.mode == "selection"  then run = run .. "gui "    end
  else
    run = run .. "screen --number " .. activeMonitor .. " "
  end

  run = run .. "--clipboard "

  hl.exec_cmd(run)
end
-- }}}

-- {{{ Color picker
local colorPickerFormat = "hex"
local colorPickerFormatIndex = 1

function ColorPicker()
  local run = "hyprpicker --autocopy --notify --render-inactive --lowercase-hex "
  run = run .. "--format " .. colorPickerFormat

  hl.exec_cmd(run)
end

function ColorPickerFormatToggle()
  local icon       = "color-select-symbolic"
  local formatList = { "hex", "rgb", "hsv", "hsl", "cmyk" }
  local index      = colorPickerFormatIndex

  index                  = (index % #formatList) + 1
  colorPickerFormatIndex = index

  local format      = formatList[index]
  colorPickerFormat = format

  PrintOSD(
  {
    icon    = icon,
    message = "Color picker format: " .. format
  })
end
-- }}}
