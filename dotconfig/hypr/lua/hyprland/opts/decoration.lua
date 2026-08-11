-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- Decoration config
--

-- {{{ Variables
local col = vars.color
local rgb = col.toRgb
-- }}}

hl.config(
{
  decoration =
  {
    rounding       = 12,
    rounding_power = 1,

    blur =
    {
      size               = 7,
      passes             = 2,
      noise              = .08,
      contrast           = 1.2,
      brightness         = 1,
      vibrancy           = 0,
      vibrancy_darkness  = 0,
      popups             = true,
      popups_ignorealpha = .1
    },

    shadow =
    {
      range          = 15,
      render_power   = 4,
      color          = rgb(col.bg4),
      color_inactive = rgb(col.bg0)
    }
  }
})

local curves =
{
  emphasizedAccel   = { type = "bezier", points = { { .3,  0 },  { .8, .15 } } },
  emphasizedDecel   = { type = "bezier", points = { { .05, .7 }, { .1, 1 } } },
  specialWorkSwitch = { type = "bezier", points = { { .05, .7 }, { .1, 1 } } },
  standard          = { type = "bezier", points = { { .2,  0 },  { 0,  1 } } },
}

-- {{{ Applying the curves in the array
for key, value in pairs(curves) do
  hl.curve(key, value)
end
-- }}}

local animations =
{
  { leaf = "layersIn",         enabled = true, speed = 3,  bezier = "emphasizedDecel",   style = "slidefadevert 50%" },
  { leaf = "layersOut",        enabled = true, speed = 3,  bezier = "emphasizedAccel",   style = "slidefadevert 50%" },
  { leaf = "fadeLayers",       enabled = true, speed = 3,  bezier = "standard" },
  { leaf = "windowsIn",        enabled = true, speed = 4,  bezier = "emphasizedDecel",   style = "popin 50%" },
  { leaf = "windowsOut",       enabled = true, speed = 4,  bezier = "emphasizedAccel",   style = "popin 50%" },
  { leaf = "windowsMove",      enabled = true, speed = 2,  bezier = "standard" },
  { leaf = "workspaces",       enabled = true, speed = 3,  bezier = "standard",          style = "slidefadevert 50%" },
  { leaf = "specialWorkspace", enabled = true, speed = 3,  bezier = "specialWorkSwitch", style = "slidefadevert 15%" },
  { leaf = "fade",             enabled = true, speed = 3,  bezier = "standard" },
  { leaf = "fadeDpms",         enabled = true, speed = 6,  bezier = "standard" },
  { leaf = "monitorAdded",     enabled = true, speed = 10, bezier = "standard" },
  { leaf = "fadeDim",          enabled = true, speed = 3,  bezier = "standard" },
  { leaf = "border",           enabled = true, speed = 6,  bezier = "standard" },
}

-- {{{ Applying the animations in the array
for _, value in pairs(animations) do
  hl.animation(value)
end
-- }}}
