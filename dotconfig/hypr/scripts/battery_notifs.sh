#!/usr/bin/env sh
## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## battery_notifs.sh by Andy3153
## created   24/01/24 ~ 13:09:27
##
## Send notifications about battery status
##

# {{{ Variables
# {{{ Which battery to check
# It can be set manually (uncomment to manually set)
#battery="/sys/class/power_supply/BAT0"

# Or automatically
if [ -z "${battery}" ]
then
  for f in /sys/class/power_supply/*
  do
    case ${f} in
      *BAT*) battery=$(echo "${f}" | head -n 1) ;;
    esac
  done
fi
# }}}

# Battery percent
bat_percent=$(cat "${battery}/capacity")

# Battery status
bat_status=$(cat "${battery}/status")
# }}}

while true
do
  sleep 1m

  if [ "${bat_status}" = "Discharging" ]
  then
    if [ "${bat_percent}" -le "10" ]
    then notify-send --urgency=critical --app-name="Battery" "Low battery" "Battery is at ${bat_percent}%. Please plug in your charger."
    fi
  fi
done
