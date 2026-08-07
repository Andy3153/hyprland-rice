-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- autostart.lua by Andy3153
-- created   04/08/26 ~ 13:28:59
--

local autostartPrograms =
{
  "brightnessctl set 100%",                                -- Reset brightness to maximum
  vars.action.brightness.keyboard .. "100%",               -- Reset keyboard brightness to maximum
  "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0",                 -- Unmute sink
  "wpctl set-volume --limit 1.5 @DEFAULT_AUDIO_SINK@ 0.5", -- Set sink volume to 50%
  vars.action.playSound .. vars.sound.loginSound,          -- Startup sound
  "launch-waybar",                                         -- Status bar
  "dunst",                                                 -- Notification daemon
  "wl-paste --type text --watch cliphist store",           -- Clipboard manager
  "wl-paste --type image --watch cliphist store",          -- [...]
  "checkFan.sh --in-notification",                         -- Fan control notification
  "batnotifsd",                                            -- Battery notifications daemon
  "openrgb --startminimized",                              -- RGB control
  "qbittorrent"                                            -- qBittorrent
}

-- {{{ Running the applications in the array
hl.on("hyprland.start", function()
  for _, value in pairs(autostartPrograms) do
    hl.exec_cmd(value)
  end
end)
-- }}}
