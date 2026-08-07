-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- General config
--

-- {{{ Variables
local col = vars.color
local rgb = col.toRgb
-- }}}

hl.config(
{
  general =
  {
    border_size = 2,
    gaps_in     = 7,
    gaps_out    = 14,

    col =
    {
      active_border   = { colors = { rgb(col.select0), rgb(col.select1) } },
      inactive_border = rgb(col.bg0)
    },

    layout           = "scrolling", -- dwindle | master | scrolling | monocle
    resize_on_border = true,
    allow_tearing    = true,
    snap             = { enabled = true }
  }
})
