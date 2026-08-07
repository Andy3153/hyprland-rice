-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- layerRules.lua by Andy3153
-- created   06/08/26 ~ 17:31:23
--

local layerRules =
{
  -- {{{ Blur layer
  {
    name  = "blur.notifications",
    match = { namespace = "notifications" },

    blur        = true,
    blur_popups = true
  },

  {
    name  = "blur.rofi",
    match = { namespace = "rofi" },

    blur        = true,
    blur_popups = true
  },

  {
    name  = "blur.swayosd",
    match = { namespace = "swayosd" },

    blur        = false,
    blur_popups = false
  },

  {
    name  = "blur.waybar",
    match = { namespace = "bar" },

    blur        = true,
    blur_popups = true
  },
  -- }}}

  -- {{{ Allow layer over lockscreen
  {
    name  = "abovelock.swayosd",
    match = { namespace = "swayosd" },

    above_lock = 1
  }
  -- }}}
}

-- {{{ Setting the layer rules in the array
for _, value in pairs(layerRules) do
  hl.layer_rule(value)
end
-- }}}
