#!/usr/bin/env lua
-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- statusBar.lua by Andy3153
-- created   20/08/26 ~ 16:29:58
--

-- {{{ Set `package.path`
local parentDir = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])")
package.path = package.path .. ";" .. parentDir .. "../../?.lua;" .. parentDir .. "../../?/init.lua"
-- }}}

-- {{{ Imports
require("lua.functions")
-- }}}

local modules = {}

if     arg[1] == "left" then
  -- {{{ Variables
  -- {{{ Weather
  local weatherInfo = GetWeatherInfo()
  local weatherIcon = weatherInfo.icon
  local weatherMsg  = weatherInfo.msg
  local weatherTemp = weatherInfo.temp
  -- }}}
  -- }}}

  -- {{{ Formatting
  if weatherIcon and weatherTemp and weatherMsg then modules.weather = weatherIcon .. "  " .. weatherTemp .. "  " .. weatherMsg end
  -- }}}

  -- {{{ Arrangement
  modules.left =
    modules.weather
  -- }}}

  print(modules.left)
elseif arg[1] == "right" then
  -- {{{ Variables
  -- {{{ Bluetooth
  local bluetoothInfo           = GetBluetoothInfo()
  local bluetoothConnectionName = bluetoothInfo.connectionName
  local bluetoothIcon           = GetBluetoothIcon(bluetoothInfo)
  local bluetoothState          = bluetoothInfo.state
  local bluetoothMsg

  if     bluetoothState == "connected" then
    bluetoothMsg = bluetoothConnectionName
  elseif bluetoothState == "on" then
    bluetoothMsg = "On"
  elseif bluetoothState == "off" then
    bluetoothMsg = "Off"
  end
  -- }}}

  -- {{{ Audio sink
  local audioSinkInfo    = GetAudioInfo("@DEFAULT_AUDIO_SINK@")
  local audioSinkIcon    = GetAudioSinkIcon(audioSinkInfo)
  local audioSinkMsg

  if audioSinkInfo.state == "muted" then
    audioSinkMsg = "Muted"
  else
    audioSinkMsg = audioSinkInfo.percentage .. "%"
  end
  -- }}}

  -- {{{ Audio source
  local audioSourceInfo    = GetAudioInfo("@DEFAULT_AUDIO_SOURCE@")
  local audioSourceIcon    = GetAudioSourceIcon(audioSourceInfo)
  local audioSourceMsg

  if audioSourceInfo.state == "muted" then
    audioSourceMsg = "Muted"
  else
    audioSourceMsg = audioSourceInfo.percentage .. "%"
  end
  -- }}}

  -- {{{ Battery
  local batName    = GetMainBat()
  local batInfo    = GetBatInfo(batName)
  local batIcon    = GetBatIcon(batInfo)
  local batMsg = batInfo.percentage .. "%"
  -- }}}

  -- {{{ Keyboard layout
  local kbLayoutIcon = "󰌌 "
  local kbLayout     = GetKeymap()
  -- }}}
  -- }}}

  -- {{{ Formatting
  if bluetoothIcon   and bluetoothMsg   then modules.bluetooth   = bluetoothIcon   .. "  " .. bluetoothMsg   end
  if audioSinkIcon   and audioSinkMsg   then modules.audioSink   = audioSinkIcon   .. "  " .. audioSinkMsg   end
  if audioSourceIcon and audioSourceMsg then modules.audioSource = audioSourceIcon .. "  " .. audioSourceMsg end
  if batIcon         and batMsg         then modules.bat         = batIcon         .. "  " .. batMsg         end
  if kbLayoutIcon    and kbLayout       then modules.kbLayout    = kbLayoutIcon    .. "  " .. kbLayout       end
  -- }}}

  -- {{{ Arrangement
  modules.right =
       modules.bluetooth   .. "      "
    .. modules.audioSink   .. "      "
    .. modules.audioSource .. "      "
    .. modules.bat         .. "      "
    .. modules.kbLayout
  -- }}}

  print(modules.right)
end
