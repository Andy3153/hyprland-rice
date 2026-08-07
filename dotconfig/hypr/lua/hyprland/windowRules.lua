-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- windowRules.lua by Andy3153
-- created   06/08/26 ~ 17:31:23
--

-- {{{ Variables
local opts = hl.get_config

local gaps_out     = opts("general.gaps_out").top
local border_size  = opts("general.border_size")
local gapAndBorder = "(" .. gaps_out .. " + " .. border_size .. ")"
-- }}}

local windowRules =
{
  -- {{{ Float window
  {
    name  = "float.pavucontrol",
    match = { title = "Volume Control" },

    center = true,
    float  = true,
    size   = { "(monitor_w * .75)", "(monitor_h * .75)" }
  },

  {
    name  = "float.blueman-manager",
    match = { class = "blueman-manager" },

    center = true,
    float  = true,
    size   = { "(monitor_w * .75)", "(monitor_h * .75)" }
  },

  {
    name  = "float.kcalc",
    match = { class = "org.kde.kcalc" },

    float = true,

    move =
    {
      "(monitor_w - (265 + " .. gapAndBorder .. "))",
      "(monitor_h - (349 + " .. gapAndBorder .. "))"
    },

    size = { 265, 349 }
  },

  {
    name = "float.librewolf-pip",

    match =
    {
      class = "librewolf",
      title = "Picture-in-Picture",
    },

    float = true,

    move =
    {
      "(monitor_w - (window_w + " .. gapAndBorder .. "))",
      "(monitor_h - (window_h + " .. gapAndBorder .. "))"
    },

    pin  = true,
    size = { 428, 241 },
  },

  {
    name = "float.vesktop-popout",

    match =
    {
      class = "vesktop",
      title = "Discord Popout",
    },

    float = true,

    move =
    {
      "(monitor_w - (window_w + " .. gapAndBorder .. "))",
      "(monitor_h - (window_h + " .. gapAndBorder .. "))"
    },

    pin  = true,
    size = { 428, 241 },
  },
  -- }}}

  -- {{{ Spawn window on certain workspace
  {
    name  = "workspace.librewolf",
    match = { class = "librewolf" },

    workspace = "3 silent"
  },

  {
    name  = "workspace.qbittorrent",
    match = { class = "org.qbittorrent.qBittorrent" },

    workspace = "7 silent"
  },

  {
    name  = "workspace.steam",
    match = { class = "steam" },

    workspace = "8 silent"
  },

  {
    name  = "workspace.heroic",
    match = { class = "heroic" },

    workspace = "8 silent"
  },

  {
    name  = "workspace.lutris",
    match = { class = "net.lutris.Lutris" },

    workspace = "8 silent"
  },

  {
    name  = "workspace.vesktop",
    match = { class = "vesktop" },

    workspace = "9 silent"
  },

  {
    name  = "workspace.ferdium",
    match = { class = "ferdium" },

    workspace = "9 silent"
  },

  {
    name  = "workspace.cantata",
    match = { class = "dog.unix.cantata.Cantata" },

    workspace = "10 silent"
  },

  {
    name  = "workspace.pear-desktop",
    match = { class = "com.github.th-ch.youtube-music" },

    workspace = "10 silent"
  },

  {
    name  = "workspace.spotify",
    match = { class = "spotify" },

    workspace = "10 silent"
  },
  -- }}}

  -- {{{ Allow tearing for window
  {
    name  = "tear.cs2",
    match = { class = "cs2" },

    immediate = true
  },
  -- }}}

  -- {{{ Flameshot
  {
    name  = "flameshot",
    match = { class = "flameshot" },

    move    = { 0, 0 },
    no_anim = true,
    pin     = true
  },
  -- }}}

  -- {{{ KRuler
  {
    name  = "kruler",
    match = { class = "org.kde.kruler" },

    border_size     = 0,
    decorate        = false,
    float           = true,
    no_blur         = true,
    no_shadow       = true,
    persistent_size = true,
    rounding        = 0,
    size            = { 1000, 70 }
  }
  -- }}}
}

-- {{{ Setting the window rules in the array
for _, value in pairs(windowRules) do
  hl.window_rule(value)
end
-- }}}
