-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- Tiling layouts config
--

-- {{{ Variables
local dsp    = hl.dsp
local layout = dsp.layout
local window = dsp.window

local currentTilingLayout = hl.get_config("general.layout")
-- }}}

hl.config(
{
  dwindle =
  {
    force_split          = 2, -- kinda spiral tiling layout
    special_scale_factor = .98
  },

  master =
  {
    allow_small_split = true,
    mfact             = .5
  },

  scrolling =
  {
    column_width       = .499,
    follow_min_visible = .15,
    wrap_focus         = false,
    wrap_swapcol       = false
  }
})

if currentTilingLayout == "scrolling" then
  hl.unbind("SUPER + CTRL + h")
  hl.unbind("SUPER + CTRL + l")
  hl.unbind("SUPER +        m")

  hl.bind("SUPER + CTRL       + h", layout("colresize -.03"), { repeating = true })
  hl.bind("SUPER + CTRL       + l", layout("colresize +.03"), { repeating = true })
  hl.bind("SUPER +            + n", layout("consume_or_expel next"))
  hl.bind("SUPER +      SHIFT + n", layout("consume_or_expel prev"))
  hl.bind("SUPER +              m", layout("fit active"))
  hl.bind("SUPER +      SHIFT + m", window.fullscreen({ mode = "maximized" }))
end
