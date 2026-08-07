-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- Miscellaneous config
--

-- {{{ Variables
local col  = vars.color
local rgb  = col.toRgb
local rgba = col.toRgba
-- }}}

hl.config(
{
  misc =
  {
    disable_hyprland_logo    = true,
    disable_splash_rendering = true,

    font_family        = "Monospace",
    splash_font_family = "Monospace",

    force_default_wallpaper = 0,
    vrr                     = 1,

    mouse_move_enables_dpms    = true,
    key_press_enables_dpms     = true,

    focus_on_activate          = true,
    allow_session_lock_restore = true,

    background_color = rgb(col.bg0)
  }
})
