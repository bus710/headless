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

confirmation(){
    term_color_red
    echo
    echo "Configure SwayWM"
    echo
    term_color_white

    echo
    sudo echo ""
    echo
}

install_packages(){
    term_color_red
    echo "Install some packages"
    term_color_white

    sudo apt install -y \
         sway \
         wofi \
         kitty \
         waybar \
         brightnessctl \
         fonts-font-awesome \
         xdg-desktop-portal-wlr \
         xorg-xwayland \
         xorg-xlsclients \
         qt5-wayland \
         glfw-wayland \
         libinput-tools

    sudo apt install -y \
         alsa-utils \
         pulseaudio \
         pipewire-pulse \
         pulseaudio-utils \
         pavucontrol

    sudo apt install -y \
         wl-clipboard \
         clipman \
         qtwayland5 \
         imv \
         zathura \
         slurp \
         grim
}

configure_sway (){
    term_color_red
    echo "Configure Sway"
    term_color_white

    # TODO: sway config
    # TODO: auto start config (zprofile)
    # TODO: kitty config
    # TODO: waybar config
    # TODO: wofi config
}

configure_keyring (){
    term_color_red
    echo "Configure Gnome keyring manager"
    term_color_white

    # TODO: gnome-keyring config
}

post (){
    term_color_red
    echo "Done"
    echo "- "
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
configure_sway
configure_keyring
post

