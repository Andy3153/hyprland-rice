#!/usr/bin/env sh
##
## suspend-compositing.sh by Andy3153
## created   16/12/23 ~ 16:02:28
##
## Imitate KDE's suspend compositing function in Hyprland
##

if [ "$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')" = 1 ]
then
  hyprctl --batch "\
    keyword animations:enabled 0;\
    keyword decoration:drop_shadow 0;\
    keyword decoration:blur:enabled 0;\
    keyword decoration:rounding 0\
    keyword windowrulev2 opaque,class:(.*)\
    keyword bind CTRL_SHIFT_SUPER, c, exec, hyprctl reload\
    "
  exit
else hyprctl reload
fi

#keyword general:gaps_in 0;\
#keyword general:gaps_out 0;\
#keyword general:border_size 1;\
