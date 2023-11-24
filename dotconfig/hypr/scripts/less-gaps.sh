#!/usr/bin/env sh
## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## less-gaps.sh by Andy3153
## created   21/11/23 ~ 17:30:23
##
## Gets my Hyprland rice in and out of a gaps mode
##

# Variables
waybardir=${XDG_CONFIG_HOME}/waybar

if [ $(readlink ${waybardir}/style.css) == "style-default.css" ]
then
  # Hyprland part
  hyprctl --batch "\
    keyword general:gaps_in 0;\
    keyword general:gaps_out 0;\
    #keyword decorations:rounding 0;\
    "

# Waybar part
unlink style.css
ln -s style-gapless.css style.css
ln -s style-default.css style.css
