#!/usr/bin/env sh
## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## suspend-compositing.sh by Andy3153
## created   16/12/23 ~ 16:02:28
## rewrote   20/12/23 ~ 15:23:34
##
## Imitate KDE's suspend compositing function in Hyprland
##
## Expands upon https://wiki.hyprland.org/Configuring/Uncommon-tips--tricks/#toggle-animationsbluretc-hotkey
##

# {{{ Variables
# Check if animations are enabled
animationsEnabled="$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')"

# Programs
notify_send="$(which notify-send)"
# }}}

# {{{ Functions
# {{{ Suspend compositing
suspendCompositing()
{
  hyprctl --batch "\
    keyword animations:enabled 0;\
    keyword decoration:drop_shadow 0;\
    keyword decoration:blur:enabled 0;\
    keyword decoration:rounding 0;\
    keyword windowrulev2 opaque,class:(.*);\
    keyword bind CTRL_SHIFT_SUPER, c, exec, hyprctl reload\
  "
}
# }}}

# {{{ Resume compositing
resumeCompositing()
{
  hyprctl reload
}
# }}}

# {{{ Toggle compositing
toggleCompositing()
{
  if [ $animationsEnabled = 1 ]
  then suspendCompositing ; $notify_send --urgency=normal --expire-time=1500 --icon=dialog-scripts --app-name="$0" "Compositing" "Compositing has been suspended."
  else resumeCompositing ; $notify_send --urgency=normal --expire-time=1500 --icon=dialog-scripts --app-name="$0" "Compositing" "Compositing has been resumed."
  fi
}
# }}}

# {{{ Help screen
helpScreen()
{
  printf "\
Usage: %s [OPTION]...\n\
Imitate KDE's suspend compositing function in Hyprland\n\
\n\
  suspend   suspend compositing\n\
  resume    resume compositing\n\
  toggle    toggle between suspending and resuming compositing\n\
  help      display this help and exit\n\
\n\
https://github.com/Andy3153\n
" "$0"
}
# }}}

# {{{ No option screen
noOptionScreen()
{
  printf "\
Usage: %s [OPTION]...\n\
Try '%s help' for more information.\n
" "$0" "$0"

  exit 1
}
# }}}
# }}}

# {{{ Check if Hyprland is running
if [ "$DESKTOP_SESSION" != "hyprland" ] && [ "$XDG_CURRENT_DESKTOP" != "Hyprland" ] && [ -n "$(which hyprctl)" ]
then
  printf "Not running Hyprland!!! Exiting.\n"
  $notify_send --urgency=critical --expire-time=1500 --icon=dialog-scripts --app-name="$0" "Compositing" "Not running Hyprland!!! Exiting."
  exit 1
fi
# }}}

# {{{ Parsing command-line options
case "$1" in
  "suspend" ) suspendCompositing ; $notify_send --urgency=normal --expire-time=1500 --icon=dialog-scripts --app-name="$0" "Compositing" "Compositing has been suspended by an external application.";;
  "resume" )  resumeCompositing ;;
  "toggle" )  toggleCompositing ;;
  "help" )    helpScreen ;;
  "" )        noOptionScreen ;;
esac
# }}}
