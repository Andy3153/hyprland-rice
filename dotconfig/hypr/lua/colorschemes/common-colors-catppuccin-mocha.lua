-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:

local col = require("lua.colorschemes.catppuccin-hyprland.themes.catppuccin-mocha")

local colors =
{
  fg0 = col.textAlpha,
  fg1 = col.subtext1Alpha,
  fg2 = col.overlay1Alpha,

  bg0 = col.baseAlpha,
  bg1 = "272737",
  bg2 = col.surface0Alpha,
  bg3 = col.surface1Alpha,
  bg4 = col.surface2Alpha,

  select0 = col.blueAlpha,
  select1 = col.lavenderAlpha,
  select2 = col.mauveAlpha,
}

-- {{{ Setting `vars.colors` to the colors in the array
for key, value in pairs(colors) do
  vars.color[key] = value
end
-- }}}
