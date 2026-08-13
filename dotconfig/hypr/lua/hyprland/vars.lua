-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- vars.lua by Andy3153
-- created   04/08/26 ~ 13:43:27
--

-- {{{ Variables
local dataHome = os.getenv("XDG_DATA_HOME")
if not dataHome then dataHome = "~/.local/share" end -- fallback if variable is not set

local screen        = "swayosd-client --brightness "
local screenControl = function(percent)
  return screen .. tostring(percent)
end

local keyboard        = "swayosd-client --device *::kbd_backlight --brightness "
local keyboardControl = function(percent)
  return keyboard .. tostring(percent)
end

local speaker = "swayosd-client --max-volume 150 --output-volume "
local speakerControl = function(percent)
  return speaker .. tostring(percent) .. " && " .. vars.action.playSound .. "audio-volume-change"
end
local speakerMute = speaker .. "mute-toggle"

local microphone = "swayosd-client --max-volume 150 --input-volume "
local microphoneControl = function(percent)
  return microphone .. tostring(percent)
end
local microphoneMute = "wpctl set-mute @DEFAULT_SOURCE@ toggle" .. " && " .. microphone .. "mute-toggle" -- no idea why swayosd can't toggle microphone mute

local media        = "swayosd-client --playerctl "
local mediaControl = function(control)
  return media .. tostring(control)
end

local terminal      = "kitty"
local terminal_exec = terminal .. " -e"
local appMenuProg   = "rofi "
local appMenu       = appMenuProg .. "-show combi"
local appMenu_dmenu = appMenuProg .. "-dmenu"

local toRgb  = function(color) return "rgb("  .. tostring(color) .. ")" end
local toRgba = function(color) return "rgba(" .. tostring(color) .. ")" end
-- }}}

vars =
{
  -- {{{ Actions
  action =
  {
    brightness =
    {
      screen        = screen,
      screenControl = screenControl,

      keyboard        = keyboard,
      keyboardControl = keyboardControl
    },

    clipboardHistory = "cliphist list | " .. appMenu_dmenu .. " -display-columns 2 | cliphist decode | wl-copy",

    lockScreen = "loginctl lock-session",
    logOut     = "wleave",

    media        = media,
    mediaControl = mediaControl,

    playSound = "canberra-gtk-play --id sounds/",
    toggleDnd = "dunst-dnd-toggle",

    volume =
    {
      speaker        = speaker,
      speakerControl = speakerControl,
      speakerMute    = speakerMute,

      microphone        = microphone,
      microphoneControl = microphoneControl,
      microphoneMute    = microphoneMute
    }
  },
  -- }}}

  -- {{{ Apps
  app =
  {
    terminal      = terminal,
    terminal_exec = terminal_exec,

    appMenu       = appMenu,
    appMenu_dmenu = appMenu_dmenu,

    editor      = "neovide",
    editor_term = terminal_exec .. " nvim",

    fileManager      = "dolphin",
    fileManager_term = terminal_exec .. " yazi",

    browser     = "librewolf",
    taskManager = terminal_exec .. " btop",
    screenshot  = "flameshot ",
    calculator  = "kcalc"
  },
  -- }}}

  -- {{{ Colors
  color =
  {
    -- actual colors declared by `lua.colorschemes.common-colors-[...]`
    toRgb  = toRgb,
    toRgba = toRgba,
  }
  -- }}}
}
