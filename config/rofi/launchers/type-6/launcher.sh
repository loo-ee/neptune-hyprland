#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Available Styles
#
## style-1     style-2     style-3     style-4     style-5
## style-6     style-7     style-8     style-9     style-10

dir="$HOME/.config/rofi/launchers/type-6"
theme='style-1'

case "${1}" in
    d|--drun) r_mode="drun" ;; 
    r|--run) r_mode="run" ;; 
    w|--window) r_mode="window" ;;
    f|--filebrowser) r_mode="filebrowser" ;;
    h|--help) echo -e "$(basename "${0}") [action]"
        echo "d :  drun mode"
        echo "r :  run mode"
        echo "w :  window mode"
        echo "f :  filebrowser mode,"
        exit 0 ;;
    *) r_mode="drun" ;;
esac

## Run
rofi \
    -show ${r_mode} \
    -theme ${dir}/${theme}.rasi
