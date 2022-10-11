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

sudo echo ""

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

create_file_and_restart_service(){
    term_color_red
    echo "Create the pulseaudio file"
    term_color_white

    sudo touch /usr/share/pipewire/media-session.d/with-pulseaudio
    systemctl --user restart pipewire-session-manager
}

trap term_color_white EXIT
create_file_and_restart_service

echo
echo "Done"
echo "- Check audio"
echo "- Rebooting can make things messed up. Just shutdown."
echo "- Check if firmware-sof-signed is installed."
echo
