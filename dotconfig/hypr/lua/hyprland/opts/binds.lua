-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
--
-- binds.lua by Andy3153
-- created   04/08/26 ~ 20:47:26
--

-- {{{ Variables
local dsp       = hl.dsp
local exec      = dsp.exec_cmd
local pass      = dsp.pass
local window    = dsp.window
local focus     = dsp.focus
local workspace = dsp.workspace
local group     = dsp.group
-- }}}

hl.config(
{
  binds =
  {
    workspace_back_and_forth    = true,
    movefocus_cycles_fullscreen = false
  }
})

-- modifier order: SUPER, CTRL, ALT, SHIFT
local binds =
{
  -- {{{ Apps
  { "SUPER         + return",         exec(vars.app.terminal) },         -- terminal
  { "SUPER         + space",          exec(vars.app.appMenu) },          -- app menu
  { "SUPER         + backslash",      exec(vars.app.editor) },           -- text editor
  { "SUPER + SHIFT + backslash",      exec(vars.app.editor_term) },      -- text editor in terminal
  { "SUPER         + e",              exec(vars.app.fileManager) },      -- file manager
  { "SUPER + SHIFT + e",              exec(vars.app.fileManager_term) }, -- file manager in terminal
  { "SUPER         + backspace",      exec(vars.app.browser) },          -- browser
  { "CTRL  + SHIFT + escape",         exec(vars.app.taskManager) },      -- task manager
  { "                XF86Calculator", exec(vars.app.calculator) },       -- calculator
  -- }}}

  -- {{{ Global binds from apps
  { "ALT + home", pass({ window = "class:^(com\\.obsproject\\.Studio)$" }) }, -- save replay buffer
  { "ALT + F11",  pass({ window = "class:^(com\\.obsproject\\.Studio)$" }) }, -- pause/unpause recording
  { "ALT + F12",  pass({ window = "class:^(com\\.obsproject\\.Studio)$" }) }, -- start/stop recording
  { "ALT + F1",   pass({ window = "class:^(com\\.obsproject\\.Studio)$" }) }, -- mute/unmute desktop audio
  { "ALT + F2",   pass({ window = "class:^(com\\.obsproject\\.Studio)$" }) }, -- mute/unmute mic
  -- }}}

  -- {{{ System functions
  { "SUPER +                v",            exec(vars.action.clipboardHistory) },                         -- clipboard manager history
  { "CTRL  + ALT  +         l",            exec(vars.action.lockScreen) },                               -- lock screen
  { "                       print",        function() Screenshot({ mode = "screen" }) end },             -- screenshot (screen)
  { "CTRL  +                print",        function() Screenshot({ mode = "allScreens" }) end },         -- screenshot (all screens)
  { "SHIFT +                print",        function() Screenshot({ mode = "selection" }) end },          -- screenshot (selection)
  { "SUPER + CTRL + SHIFT + x",            exec("hyprctl kill") },                                       -- xkill alternative
  { "SUPER + CTRL + SHIFT + c",            exec("suspend_compositing --notify toggle") },                -- suspend compositing
  { "SUPER + CTRL + SHIFT + q",            exec(vars.action.logOut) },                                   -- power menu
  { "                       XF86PowerOff", exec(vars.action.logOut) },                                   -- [ ... ]
  { "SUPER + CTRL + SHIFT + l",            function() LidSwitchBehaviorToggle() end, { locked = true }}, -- lid switch behavior toggle
  { "SUPER + CTRL + SHIFT + d",            function() DndToggle() end },                                 -- DnD mode
  { "SUPER + CTRL + SHIFT + i",            function() IdleInhibitToggle() end },                         -- idle inhibit toggle

  -- {{{ Media keys
  -- {{{ Speaker volume
  { "XF86AudioRaiseVolume", exec(vars.action.volume.speakerControl("+5")), { locked = true, repeating = true } }, -- speaker volume up
  { "XF86AudioLowerVolume", exec(vars.action.volume.speakerControl("-5")), { locked = true, repeating = true } }, -- speaker volume down
  { "XF86AudioMute",        exec(vars.action.volume.speakerMute),          { locked = true, } },                  -- speaker mute
  -- }}}

  -- {{{ Microphone volume
  { "        XF86AudioMicMute",     exec(vars.action.volume.microphoneMute),          { locked = true, } },                  -- microphone mute
  { "SHIFT + XF86AudioRaiseVolume", exec(vars.action.volume.microphoneControl("+5")), { locked = true, repeating = true } }, -- microphone volume up
  { "SHIFT + XF86AudioLowerVolume", exec(vars.action.volume.microphoneControl("-5")), { locked = true, repeating = true } }, -- microphone volume down
  { "SHIFT + XF86AudioMute",        exec(vars.action.volume.microphoneMute),          { locked = true, } },                  -- microphone mute
  -- }}}

  -- {{{ Screen brightness level
  { "XF86MonBrightnessUp",   exec(vars.action.brightness.screenControl("+5")), { locked = true, repeating = true } }, -- screen brightness up
  { "XF86MonBrightnessDown", exec(vars.action.brightness.screenControl("-5")), { locked = true, repeating = true } }, -- screen brightness down
  -- }}}

  ---- {{{ Keyboard brightness level
  { "        XF86KbdBrightnessUp",   exec(vars.action.brightness.keyboardControl("+33")), { locked = true, repeating = true } }, -- keyboard brightness up
  { "        XF86KbdBrightnessDown", exec(vars.action.brightness.keyboardControl("-33")), { locked = true, repeating = true } }, -- keyboard brightness down
  { "SHIFT + XF86MonBrightnessUp",   exec(vars.action.brightness.keyboardControl("+33")), { locked = true, repeating = true } }, -- keyboard brightness up
  { "SHIFT + XF86MonBrightnessDown", exec(vars.action.brightness.keyboardControl("-33")), { locked = true, repeating = true } }, -- keyboard brightness down
  ---- }}}

  -- {{{ Media player control
  { "       XF86AudioNext",        exec(vars.action.mediaControl("next")),       { locked = true } }, -- media player next
  { "       XF86AudioPrev",        exec(vars.action.mediaControl("prev")),       { locked = true } }, -- media player previous
  { "       XF86AudioPlay",        exec(vars.action.mediaControl("play-pause")), { locked = true } }, -- media player play/pause
  { "CTRL + XF86AudioRaiseVolume", exec(vars.action.mediaControl("next")),       { locked = true } }, -- media player next
  { "CTRL + XF86AudioLowerVolume", exec(vars.action.mediaControl("prev")),       { locked = true } }, -- media player previous
  { "CTRL + XF86AudioMute",        exec(vars.action.mediaControl("play-pause")), { locked = true } }, -- media player play/pause
  -- }}}
  -- }}}
  -- }}}

  -- {{{ Window
  { "SUPER +         h",         focus({ direction = "left" }) },
  { "SUPER +         j",         focus({ direction = "down" }) },
  { "SUPER +         k",         focus({ direction = "up" }) },
  { "SUPER +         l",         focus({ direction = "right" }) },
  { "ALT   +         Tab",       window.cycle_next() },
  { "ALT   +         Tab",       window.bring_to_top() },

  { "SUPER + SHIFT + h",         window.move({ direction = "left" }) },
  { "SUPER + SHIFT + j",         window.move({ direction = "down" }) },
  { "SUPER + SHIFT + k",         window.move({ direction = "up" }) },
  { "SUPER + SHIFT + l",         window.move({ direction = "right" }) },

  { "SUPER + CTRL  + h",         window.resize({ x = -30, y = 0,   relative = true }, { repeating = true }) },
  { "SUPER + CTRL  + j",         window.resize({ x = 0,   y = 30,  relative = true }, { repeating = true }) },
  { "SUPER + CTRL  + k",         window.resize({ x = 0,   y = -30, relative = true }, { repeating = true }) },
  { "SUPER + CTRL  + l",         window.resize({ x = 30,  y = 0,   relative = true }, { repeating = true }) },
  { "SUPER +         mouse:272", window.drag() },
  { "SUPER +         mouse:273", window.resize() },

  { "SUPER +         m",         window.fullscreen({ mode = "maximized" }) },
  { "SUPER +         f",         window.fullscreen({ mode = "fullscreen" }) },
  { "CTRL  + SHIFT + q",         window.close() },
  { "SUPER + SHIFT + return",    window.float() },
  { "SUPER +         p",         window.pin() },
  -- }}}

  -- {{{ Workspace
  { "SUPER + 1",             focus({ workspace = 1 }) },
  { "SUPER + 2",             focus({ workspace = 2 }) },
  { "SUPER + 3",             focus({ workspace = 3 }) },
  { "SUPER + 4",             focus({ workspace = 4 }) },
  { "SUPER + 5",             focus({ workspace = 5 }) },
  { "SUPER + 6",             focus({ workspace = 6 }) },
  { "SUPER + 7",             focus({ workspace = 7 }) },
  { "SUPER + 8",             focus({ workspace = 8 }) },
  { "SUPER + 9",             focus({ workspace = 9 }) },
  { "SUPER + 0",             focus({ workspace = 10 }) },
  { "SUPER + grave",         workspace.toggle_special("special") },

  { "SUPER + SHIFT + 1",     window.move({ workspace = 1,         follow = false }) },
  { "SUPER + SHIFT + 2",     window.move({ workspace = 2,         follow = false }) },
  { "SUPER + SHIFT + 3",     window.move({ workspace = 3,         follow = false }) },
  { "SUPER + SHIFT + 4",     window.move({ workspace = 4,         follow = false }) },
  { "SUPER + SHIFT + 5",     window.move({ workspace = 5,         follow = false }) },
  { "SUPER + SHIFT + 6",     window.move({ workspace = 6,         follow = false }) },
  { "SUPER + SHIFT + 7",     window.move({ workspace = 7,         follow = false }) },
  { "SUPER + SHIFT + 8",     window.move({ workspace = 8,         follow = false }) },
  { "SUPER + SHIFT + 9",     window.move({ workspace = 9,         follow = false }) },
  { "SUPER + SHIFT + 0",     window.move({ workspace = 10,        follow = false }) },
  { "SUPER + SHIFT + grave", window.move({ workspace = "special", follow = false }) },
  -- }}}

  -- {{{ Group
  { "SUPER +         t",      group.toggle() },
  { "SUPER +         comma",  group.prev() },
  { "SUPER +         period", group.next() },
  { "SUPER + SHIFT + t",      window.move({ out_of_group = true }) },
  { "SUPER + ALT   + t",      window.move({ out_of_group = true }) },
  { "SUPER + ALT   + h",      window.move({ into_group = "left" }) },
  { "SUPER + ALT   + j",      window.move({ into_group = "down" }) },
  { "SUPER + ALT   + k",      window.move({ into_group = "up" }) },
  { "SUPER + ALT   + l",      window.move({ into_group = "right" }) }
  -- }}}
}

-- {{{ Applying the binds in the array
for _, value in pairs(binds) do
  if value[3] then
    hl.bind(value[1], value[2], value[3])
  else hl.bind(value[1], value[2])
  end
end
-- }}}
