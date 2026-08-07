-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- monitors.lua by Andy3153
-- created   04/08/26 ~ 02:30:23
--

local monitors =
{
  -- {{{ `sparkle` | ASUS TUF F15 FX506HM
  {
    output = "desc:Sharp Corporation LQ156M1JW26",
    mode   = "1920x1080@240",
    scale  = "1",
    vrr    = 1
  },
  -- }}}

  -- {{{ `fidget` | Lenovo Thinkpad X280
  {
    output = "desc:Chimei Innolux Corporation 0x1239",
    mode   = "1920x1080@60",
    scale  = "1.2",
    vrr    = 1
  },
  -- }}}

  -- {{{ Home monitor
  {
    output = "desc:Dell Inc. DELL S2721HN H82MSJ3",
    mode   = "1920x1080@75",
    scale  = "1",
    vrr    = 1
  },
  -- }}}

  -- {{{ Home TV
  {
    output = "desc:Samsung Electric Company SAMSUNG 0x01000600",
    mode   = "3840x2160@75",
    scale  = "2",
    vrr    = 1
  },
  -- }}}

  -- {{{ TV
  {
    output = "desc:Samsung Electric Company SAMSUNG",
    mode   = "1366x768@60",
    scale  = "1",
    vrr    = 1
  },
  -- }}}

  -- {{{ Dummy plug
  {
    output   = "desc:BBC HDP-V104 demoset-1",
    disabled = true
  },
  -- }}}

  -- {{{ Catch-all
  {
    output = "",
    mode   = "preferred",
    vrr    = 1
  }
  -- }}}
}

-- {{{ Applying the monitors in the array
for _, value in pairs(monitors) do
  hl.monitor(value)
end
-- }}}
