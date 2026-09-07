-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- Input config
--

hl.config(
{
  input =
  {
    kb_layout          = "us,ro",
    kb_options         = "grp:alt_shift_toggle",
    kb_variant         = ",std",
    numlock_by_default = true,
    repeat_delay       = 300,
    repeat_rate        = 20,

    accel_profile = "flat",
    sensitivity   = .1,

    follow_mouse_shrink    = 30,
    follow_mouse_threshold = 10,

    touchpad =
    {
      disable_while_typing = false,
      natural_scroll = true,
      scroll_factor = .8,
    },
  }
})

local devices =
{
  -- {{{ sparkle | ASUS TUF F15 FX506HM
  -- {{{ Touchpad
  {
    name          = "elan1203:00-04f3:307a-touchpad",
    accel_profile = "adaptive",
    sensitivity   = .6
  },
  -- }}}
  -- }}}

  -- {{{ fidget | Lenovo ThinkPad X280
  -- {{{ Touchpad
  {
    name          = "synaptics-tm3381-002",
    accel_profile = "adaptive",
    sensitivity   = .4
  },
  -- }}}

  -- {{{ Trackpoint
  {
    name          = "tpps/2-elan-trackpoint",
    accel_profile = "adaptive",
    sensitivity   = .2
  }
  -- }}}
  -- }}}
}

-- {{{ Applying the devices in the array
for _, value in pairs(devices) do
  hl.device(value)
end
-- }}}

