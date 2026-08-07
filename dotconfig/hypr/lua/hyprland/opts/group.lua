-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- Group config
--

-- {{{ Variables
local col  = vars.color
local rgb  = col.toRgb
local rgba = col.toRgba
-- }}}

hl.config(
{
  group =
  {
    col =
    {
      border_active   = { colors = { rgb(col.select0), rgb(col.select2) } },
      border_inactive = rgb(col.bg0)
    },

    -- {{{ Groupbar
    groupbar =
    {
      font_family          = "Monospace",
      font_size            = 12,
      font_weight_active   = "semibold",
      font_weight_inactive = "light",
      gradients            = true,

      height           = 20,
      indicator_gap    = 0,
      indicator_height = 0,

      gradient_rounding         = 10,
      gradient_round_only_edges = false,

      text_color          = rgb(col.fg0),
      text_color_inactive = rgb(col.fg1),

      col =
      {
        active   = rgba(col.bg3 .. "cc"),
        inactive = rgba(col.bg0 .. "cc")
      },

      gaps_in        = 2,
      gaps_out       = 2,
      keep_upper_gap = false,

      blur = true
    }
    -- }}}
  },
})
