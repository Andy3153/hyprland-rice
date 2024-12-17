#!/bin/sh

cava_folder="${XDG_CONFIG_HOME}/cava"

kitty --config "${cava_folder}/kitty-cava.conf" --class "kitty-cava" cava
