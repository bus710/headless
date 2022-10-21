#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

TIGER_LAKE=$(lspci | grep TigerLake | wc -l)

if [[ ! $TIGER_LAKE =~ "1" ]]; then
    echo
    echo "Not TigerLake device"
    echo
    exit
fi

echo
echo "Configure TigerLake audio"
echo

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

start_service(){
    term_color_red
    echo "Start pulseaudio service"
    term_color_white

    #sudo touch /usr/share/pipewire/media-session.d/with-pulseaudio
    #systemctl --user restart pipewire-session-manager

    systemctl --user start pulseaudio
    pulseaudio --start
    pavucontrol
}

trap term_color_white EXIT
start_service

echo
echo "Done"
echo
