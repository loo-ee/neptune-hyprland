#!/bin/bash

if pgrep -x "hypridle" > /dev/null
then
  pkill -x "hypridle"
  notify-send  -a "t2" -r 91190 -t 800 -i "hypridle toggle" "hypridle" "stopped"
  exit 0
else 
  hypridle &
  notify-send  -a "t2" -r 91190 -t 800 -i "hypridle started" "hypridle" "started"
  exit 0
fi
