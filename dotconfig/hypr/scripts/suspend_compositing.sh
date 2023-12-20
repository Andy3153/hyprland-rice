#!/usr/bin/env sh
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
animationsEnabled="$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')"
# }}}

# {{{ Functions
# {{{ Suspend compositing
suspendCompositing()
{
  hyprctl --batch "\
    keyword animations:enabled 0;\
    keyword decoration:drop_shadow 0;\
    keyword decoration:blur:enabled 0;\
    keyword decoration:rounding 0\
    keyword windowrulev2 opaque,class:(.*)\
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
  then suspendCompositing
  else resumeCompositing
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
https://github.com/Andy3153
" "$0"
}
# }}}

# {{{ No option screen
noOptionScreen()
{
  printf "\
Usage: %s [OPTION]...\n\
Try '%s help' for more information.
" "$0" "$0"

  exit 1
}
# }}}
# }}}

# {{{ Parsing command-line options
case "$1" in
  "suspend" ) suspendCompositing ;;
  "resume" )  resumeCompositing ;;
  "toggle" )  toggleCompositing ;;
  "help" )    helpScreen ;;
  "" )        noOptionScreen ;;
esac
# }}}