-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- functions.lua by Andy3153
-- created   20/08/26 ~ 23:13:13
--

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
function ExecCmd(cmd)
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

-- {{{ Weather
function GetWeatherInfo()
  local weatherInfo = {}
  local weather     = ExecCmd("weather4bar")
  local count       = 0

  for line in weather:gmatch("([^\n]*)\n?") do
    count = count + 1

    if count == 1 then weatherInfo.icon          = line end
    if count == 2 then weatherInfo.temp          = line end
    if count == 3 then weatherInfo.city          = line end
    if count == 5 then weatherInfo.msg           = line end
    if count == 6 then weatherInfo.feelsLikeTemp = line:match('Feels like ([%d%.%-]+)') end
  end

  return weatherInfo
end
-- }}}

-- {{{ Bluetooth
-- {{{ Get bluetooth info
function GetBluetoothInfo(device)
  local bluetoothInfo  = {}
  local connectionName = ExecCmd("bluetoothctl devices Connected"):match("Device %S+ (.+)\n")
  local state          = ExecCmd("bluetoothctl show"):match("Powered:%s*([%w%-]+)")

  if state == "no" then
    bluetoothInfo.state = "off"
  else
    bluetoothInfo.state = "on"
  end

  if connectionName then
    bluetoothInfo.connectionName = connectionName
    bluetoothInfo.state          = "connected"
  end

  return bluetoothInfo
end
-- }}}

-- {{{ Get bluetooth icon
local bluetoothIcons =
{
  off = "󰂲", on = "󰂯", connected = "󰂱"
}

function GetBluetoothIcon(bluetoothInfo)
  local connectionName = bluetoothInfo.connectionName
  local state          = bluetoothInfo.state

  local bluetoothIcon

  if     state == "connected" then
    bluetoothIcon = bluetoothIcons.connected
  elseif state == "on" then
    bluetoothIcon = bluetoothIcons.on
  elseif state == "off" then
    bluetoothIcon = bluetoothIcons.off
  end

  return bluetoothIcon
end
-- }}}
-- }}}

-- {{{ Audio
-- {{{ Get audio info
function GetAudioInfo(device)
  local audioInfo  = {}
  local audio      = ExecCmd("wpctl get-volume " .. device)
  local state      = "unmuted"
  local percentage = audio:match("Volume:%s*([%d%.]+)")

  if audio:match("%[MUTED%]") ~= nil then state  = "muted" end

  if state      then audioInfo.state      = state end
  if percentage then audioInfo.percentage = tonumber(percentage) * 100 end

  return audioInfo
end
-- }}}

-- {{{ Get audio sink icon
local audioSinkIcons =
{
  _0p = "󰕿", _50p = "󰖀", _100p = "󰕾",
  muted = "󰖁"
}

local function audioSinkIconPercent(percentage)
  if     percentage <   35 then return audioSinkIcons._0p
  elseif percentage <   70 then return audioSinkIcons._50p
  elseif percentage >= 100 then return audioSinkIcons._100p
  end
end

function GetAudioSinkIcon(audioSinkInfo)
  local state      = audioSinkInfo.state
  local percentage = audioSinkInfo.percentage

  local audioSinkIcon

  if state == "unmuted" then
    audioSinkIcon = audioSinkIconPercent(percentage)
  else
    audioSinkIcon = audioSinkIcons.muted
  end

  return audioSinkIcon
end
-- }}}

-- {{{ Get audio source icon
local audioSourceIcons =
{
  _100p = "󰍬",
  muted = "󰍭"
}

local function audioSourceIconPercent(percentage)
  return audioSourceIcons._100p
end

function GetAudioSourceIcon(audioSourceInfo)
  local state      = audioSourceInfo.state
  local percentage = audioSourceInfo.percentage

  local audioSourceIcon

  if state == "unmuted" then
    audioSourceIcon = audioSourceIconPercent(percentage)
  else
    audioSourceIcon = audioSourceIcons.muted
  end

  return audioSourceIcon
end
-- }}}
-- }}}

-- {{{ Keymap
function GetKeymap()
  output = ExecCmd("hyprctl devices -j")
  return output:match('{.-"main"%s*:%s*true.-"active_keymap"%s*:%s*"(.-)".-}')
end
-- }}}

-- {{{ Battery
local function upowerEnumerateDevices()    return ExecCmd("upower --enumerate") end
local function upowerGetDeviceInfo(device) return ExecCmd("upower --show-info " .. device) end

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
  critical = "󱈸"
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
  elseif percentage <= 100 then return batteryIcons._100p
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
