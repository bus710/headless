#!/bin/bash

set -e


if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation (){
    term_color_red
    echo ""
    echo "Install and configure Wine? (y/n)"
    echo ""
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo
        exit 1
    fi
}

function install(){
    echo 
    echo "Install prerequisites and Wine"
    echo 

    LSB_RELEASE_CODENAME=$(lsb_release -cs)


    sudo dpkg --add-architecture i386
    sudo apt install -y wayland

    sudo rm -rf /etc/apt/keyrings/winehq-archive.key
    sudo mkdir -pm755 /etc/apt/keyrings
    sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

    sudo wget -NP \
        /etc/apt/sources.list.d/ \
        https://dl.winehq.org/wine-builds/debian/dists/${LSB_RELEASE_CODENAME}/winehq-${LSB_RELEASE_CODENAME}.sources

    sudo apt update

    sudo apt install --install-recommends winehq-stable
}

function post(){
    term_color_red
    echo
    term_color_white
}

trap post EXIT
confirmation
install
post

# General info
# https://gitlab.winehq.org/wine/wine/-/wikis/Debian-Ubuntu

# To install an Windows app:
# $ wine RidibooksSetup.exe

# Once install, it can be found:
# $ wine ~/.wine/drive_c/Program\ Files/RIDI/Ridibooks/Ridibooks.exe

# Must reboot once install. Otherwise you will see this error:
# nodrv_CreateWindow Application tried to create a window, but no driver could be loaded.

# If fonts are broken, install winetricks (from contrib repo), and do this:
# winetricks corefonts

# To remove all i385 if needed
# $ sudo dpkg --remove-architecture i386
# $ sudo apt purge "*:i386" --allow-remove-essential
