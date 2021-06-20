#!/bin/bash

set -e

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
        --property "/xfwm4/custom/<Super>d" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>d" \
        --create --type string --set show_desktop_key

    # Set Super + Left to tile window to left
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/default/<Super>KP_Left" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>KP_Left" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>Left" \
        --create --type string --set tile_left_key

    # Set Super + Right to tile window to right
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/default/<Super>KP_Right" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>KP_Right" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/xfwm4/custom/<Super>Right" \
        --create --type string --set tile_right_key

    echo
    echo "Create shortcuts for xfce4 app control"
    echo

    # This is for shortcuts of apps (settings => keyboard => app shortcuts)

    # Set Super + l to open session logout panel
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>l" \
        --create --type string --set xfce4-session-logout

    # Set Super + s to open settings manager
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>s" \
        --create --type string --set xfce4-settings-manager 

    # Set Super + a to open appfinder
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>a" \
        --create --type string --set xfce4-appfinder

    # Set Super + q to open terminal
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>q" \
        --create --type string --set xfce4-terminal

    # Set Super + z to open screen shooter
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>z" \
        --create --type string --set xfce4-screenshooter

    # Set Super + x to open remmina
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>x" \
        --create --type string --set remmina

    # Set Super + w to open chrome
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>w" --reset
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>w" \
        --create --type string --set google-chrome

    # Set Super + c to open vscode
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>c" \
        --create --type string --set code-insiders

    # Set Super + v to open vscode
    xfconf-query --channel xfce4-keyboard-shortcuts \
        --property "/commands/custom/<Super>v" \
        --create --type string --set code
fi

echo
echo "Done"
echo
