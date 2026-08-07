-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- envvars.lua by Andy3153
-- created   04/08/26 ~ 16:37:51
--

local environmentVariables =
{
  -- {{{ Toolkit backend variables
  GDK_BACKEND                  = "wayland,x11,*",
  QT_QPA_PLATFORM              = "wayland;xcb",
  SDL_VIDEODRIVER              = "wayland",
  MOZ_ENABLE_WAYLAND           = 1,
  CLUTTER_BACKEND              = "wayland",
  ELECTRON_OZONE_PLATFORM_HINT = "auto",
  NIXOS_OZONE_WL               = 1,
  -- }}}

  -- {{{ Use portals
  GTK_USE_PORTAL = 1,
  -- }}}

  -- {{{ Java window fix
  _JAVA_AWT_WM_NONREPARENTING = 1,
  -- }}}
}

-- {{{ Setting the environment variables in the array
for key, value in pairs(environmentVariables) do
  hl.env(key, value)
end
-- }}}
