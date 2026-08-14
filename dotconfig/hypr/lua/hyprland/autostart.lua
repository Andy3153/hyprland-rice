-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- autostart.lua by Andy3153
-- created   04/08/26 ~ 13:28:59
--

local autostartPrograms =
{
  -- Inhibit power key
  SystemdInhibitStart(
  {
    what        = "handle-power-key",
    who         = "Hyprland Rice",
    why         = "Inhibit power key (managed by Hyprland config)",
    pidFileName = "inhibitPowerKey",
    dontRun     = true
  }),

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

local logoutPrograms =
{
  SystemdInhibitStop({ pidFileName = "inhibitLidSwitch" }), -- Close lid switch mode inhibitor
  SystemdInhibitStop({ pidFileName = "inhibitIdle" }),      -- Close idle inhibitor
  SystemdInhibitStop({ pidFileName = "inhibitPowerKey" })   -- Close power key inhibitor
}

-- {{{ Running the applications in the autostart array
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

-- {{{ Running the applications in the logout array
hl.on("hyprland.shutdown", function()
  for _, value in pairs(logoutPrograms) do
    hl.exec_cmd(value)
  end
end)
-- }}}
