-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}} pa+=../../../:
--
-- opts by Andy3153
-- created   04/08/26 ~ 18:21:34
--

require("lua.hyprland.opts.general")
require("lua.hyprland.opts.decoration")
require("lua.hyprland.opts.input")
require("lua.hyprland.opts.gestures")
require("lua.hyprland.opts.group")
require("lua.hyprland.opts.misc")
require("lua.hyprland.opts.binds")
require("lua.hyprland.opts.layouts")

hl.config(
{
  render = { direct_scanout = 2 },
  cursor = { persistent_warps = true },
})
