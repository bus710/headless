#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

AUDIO_DEVICE=$(lspci | grep Audio)

echo
echo "Restart audio"
echo "$AUDIO_DEVICE"
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
