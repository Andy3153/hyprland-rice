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
function InspectTable(t, indent, visited)
  indent  = indent or 0
  visited = visited or {}

  if type(t) ~= "table" then return tostring(t) end

  if visited[t] then return "[circular reference]" end

  visited[t] = true

  local result     = "{\n"
  local indent_str = string.rep("  ", indent + 1)

  for k, v in pairs(t) do
    local key_str = type(k) == "string" and '"' .. k .. '"' or k
    local val_str = InspectTable(v, indent + 1, visited)

    result = result .. indent_str .. key_str .. " = " .. val_str .. ",\n"
  end

  result = result .. string.rep("  ", indent) .. "}"

  return result
end
-- }}}

-- {{{ Execute command and return stdout
local function execCmd(cmd)
  local handle = io.popen(cmd)
  if handle then
    local output = handle:read("*a")
    handle:close()
    return output
  else
    return nil
  end
end
-- }}}

-- {{{ Print to Hyprland notifications
--
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Notifications/
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Using-hyprctl/#notify
--

function Print(text)
  text             = InspectTable(text)
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

-- {{{ Keymap
function GetKeymap()
  output = execCmd("hyprctl devices -j")
  return output:match('{.-"main"%s*:%s*true.-"active_keymap"%s*:%s*"(.-)".-}')
end
-- }}}

-- {{{ Battery
local function upowerEnumerateDevices()    return execCmd("upower --enumerate") end
local function upowerGetDeviceInfo(device) return execCmd("upower --show-info " .. device) end

-- {{{ Get main battery
function GetMainBat()
  local devices = upowerEnumerateDevices()

  if devices then
    for device in devices:gmatch("[^\r\n]+") do
      if device:match("battery") then
        local deviceInfo = upowerGetDeviceInfo(device)

        if deviceInfo and deviceInfo:match("power supply:%s+yes") then
          return device
        end
      end
    end
  end
end
-- }}}

-- {{{ Get battery info
function GetBatInfo(device)
  local batteryInfo  = {}
  local battery      = upowerGetDeviceInfo(device)
  local state        = battery:match("state:%s*([%w%-]+)")
  local percentage   = battery:match("percentage:%s*(%d+)%%")
  local warningLevel = battery:match("warning%-level:%s*([%w%-]+)")

  if state        then batteryInfo.state        = state end
  if percentage   then batteryInfo.percentage   = tonumber(percentage) end
  if warningLevel then batteryInfo.warningLevel = warningLevel end

  return batteryInfo
end
-- }}}

-- {{{ Get battery icon
local batteryIcons =
{
  _0p  = "󰂎", _10p = "󰁺", _20p  = "󰁻", _30p = "󰁼",
  _40p = "󰁽", _50p = "󰁾", _60p  = "󰁿", _70p = "󰂀",
  _80p = "󰂁", _90p = "󰂂", _100p = "󰁹",
  charging = "󱐋",
  critical = "󱈸",
}

local function batteryIconPercent(percentage)
  if     percentage ==   0 then return batteryIcons._0p
  elseif percentage <   10 then return batteryIcons._10p
  elseif percentage <   20 then return batteryIcons._20p
  elseif percentage <   30 then return batteryIcons._30p
  elseif percentage <   40 then return batteryIcons._40p
  elseif percentage <   50 then return batteryIcons._50p
  elseif percentage <   60 then return batteryIcons._60p
  elseif percentage <   70 then return batteryIcons._70p
  elseif percentage <   80 then return batteryIcons._80p
  elseif percentage <   90 then return batteryIcons._90p
  elseif percentage <  100 then return batteryIcons._100p
  end
end

function GetBatIcon(batInfo)
  local state        = batInfo.state
  local percentage   = batInfo.percentage
  local warningLevel = batInfo.warningLevel
  local batteryIcon  = batteryIconPercent(percentage)

  if warningLevel == "critical" then
    batteryIcon = batteryIcon .. batteryIcons.critical
  end

  if state == "charging" or state == "fully-charged" then
    batteryIcon = batteryIcon .. batteryIcons.charging
  end

  return batteryIcon
end
-- }}}
-- }}}
