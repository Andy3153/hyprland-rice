-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- Tiling layouts config
--

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
