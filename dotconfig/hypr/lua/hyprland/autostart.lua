-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- autostart.lua by Andy3153
-- created   04/08/26 ~ 13:28:59
--

local autostartPrograms =
{
  {
    "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0",                 -- Unmute speaker
    "wpctl set-volume --limit 1.5 @DEFAULT_AUDIO_SINK@ 0.5", -- Set speaker volume to 50%
    vars.action.playSound .. vars.sound.loginSound,          -- Startup sound
  },

  "brightnessctl set 100%",                       -- Set brightness to maximum
  vars.action.brightness.keyboard .. "100%",      -- Set keyboard brightness to maximum
  "waybar",                                       -- Status bar
  "dunst",                                        -- Notification daemon
  "wl-paste --type text  --watch cliphist store", -- Clipboard manager
  "wl-paste --type image --watch cliphist store", -- [...]
  "checkFan.sh --in-notification",                -- Fan control notification
  "batnotifsd",                                   -- Battery notifications daemon
  "openrgb --startminimized",                     -- RGB control
  "qbittorrent"                                   -- qBittorrent
}

-- {{{ Running the applications in the array
hl.on("hyprland.start", function()
  for _, value in pairs(autostartPrograms) do
    -- Execute arrays sequentially
    if type(value) == "table" then
      local sequentialExec = ""

      for _, value2 in pairs(value) do
        sequentialExec = sequentialExec .. value2

        if value2 ~= value[#value] then
          sequentialExec = sequentialExec .. " ; "
        end
      end

      hl.exec_cmd(sequentialExec)
    else
      hl.exec_cmd(value)
    end
  end
end)
-- }}}
