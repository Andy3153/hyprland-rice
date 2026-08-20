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
