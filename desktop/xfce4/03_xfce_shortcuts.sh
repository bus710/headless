#!/bin/bash

set -e

CPU_VENDOR=$(lscpu | grep Vendor | awk -F " " '{print $3}');
if [[ $CPU_VENDOR =~ "ARM" ]]; then
    KEY="<Super><Alt>"
else
    KEY="<Super>"
fi

echo $KEY

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

if [[ ! $XDG_CURRENT_DESKTOP =~ "XFCE" ]]; then
    echo
    echo "Not XFCE."
    echo
    exit

elif [[ $XDG_CURRENT_DESKTOP =~ "XFCE" ]]; then
    echo
    echo "Create shortcuts for xfce4 window control"
    echo

    # If below keys don't work, 
    # visit Settings => Settings Editor => xfce4-keyboard-shortcuts.
    # and remove all the overlapping entries for tile_left_key and tile_right_key
    # then run this script again

    # To confirm,
    # xfconf-query --channel xfce4-keyboard-shortcuts -lv 

    # Set Super + d to to show desktop
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/${KEY}d" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/${KEY}d" \
        --create --type string --set show_desktop_key

    # Set Super + Left to tile window to left
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/default/${KEY}KP_Left" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/${KEY}KP_Left" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/${KEY}Left" \
        --create --type string --set tile_left_key

    # Set Super + Right to tile window to right
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/default/${KEY}KP_Right" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/${KEY}KP_Right" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/${KEY}Right" \
        --create --type string --set tile_right_key

    echo
    echo "Create shortcuts for xfce4 app control"
    echo

    # This is for shortcuts of apps (settings => keyboard => app shortcuts)

    # Set Super + Alt + 1 to open terminal
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}1" \
        --create --type string --set xfce4-terminal

    # Set Super + Alt + 2 to open settings manager
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}2" \
        --create --type string --set xfce4-settings-manager 

    # Set Super + Alt + 3 to open appfinder
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}3" \
        --create --type string --set xfce4-appfinder

    # Set Super + Alt + 4 to open taskmanager 
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}4" \
        --create --type string --set xfce4-taskmanager

    # =================

    # Set Super + q to open screen shooter
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}q" \
        --create --type string --set xfce4-screenshooter

    # Set Super + w to open chrome
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}w" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}w" \
        --create --type string --set google-chrome

    # Set Super + e to open thunar
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}e" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}e" \
        --create --type string --set thunar

    # Set Super + z to open remmina
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}z" \
        --create --type string --set remmina

    # Set Super + x to open vscode
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}x" \
        --create --type string --set code-insiders

    # Set Super + c to open vscode insider
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}c" \
        --create --type string --set code

    # Set Super + k to open session logout panel
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}k" \
        --create --type string --set xfce4-session-logout

    # Set Super + l to open session logout panel
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/${KEY}l" \
        --create --type string --set "dm-tool lock"
fi

echo
echo "Done"
echo
