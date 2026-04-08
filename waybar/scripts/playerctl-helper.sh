#!/bin/bash
#     󰏤

status=$(playerctl status 2>/dev/null) || exit 0
if [ "$status" == "Stopped" ]; then
  echo derp
  exit 0;
fi

echo $(playerctl metadata --format {{emoji(status) playerName}})

