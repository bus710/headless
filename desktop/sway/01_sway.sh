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
    echo "Install and configure SwayWM? (y/n)"
    echo ""
    term_color_white
    
    echo
    read -n 1 ans
    echo
    
    if [[ ! $ans == "y" ]]; then
        echo
        exit -1
    fi
}

install_packages(){
    term_color_red
    echo "Install some packages"
    term_color_white

    # Basic
    sudo apt install -y \
         sway \
         wofi \
         kitty \
         waybar \
         brightnessctl \
         fonts-font-awesome \
         libinput-tools
         #xorg-xwayland \
         #xorg-xlsclients \
         #qt5-wayland \
         #glfw-wayland \

    # Audio
    sudo apt install -y \
         alsa-utils \
         pulseaudio \
         pulseaudio-utils \
         pulseaudio-module-bluetooth \
         pipewire-pulse \
         pavucontrol
         #pulseaudio-alsa \

    sudo usermod -aG audio $LOGNAME

    # Clip board and screen capture/sharing
    sudo apt install -y \
         xdg-desktop-portal-wlr \
         wl-clipboard \
         clipman \
         slurp \
         grim

    # Extra apps and theming
    sudo apt install -y \
         qtwayland5 \
         ristretto \
         zathura \
         inxi \
         mpv \
         imv

    # Auth
    sudo apt install -y \
        gnome-keyring \
        sshfs
}

configure_sway (){
    term_color_red
    echo "Configure Sway"
    term_color_white

    rm -rf /home/$LOGNAME/Downloads
    mkdir /home/$LOGNAME/Downloads

    # sway config
    rm -rf /home/$LOGNAME/.config/sway
    mkdir /home/$LOGNAME/.config/sway
    cp dotfiles/10_sway_config /home/$LOGNAME/.config/sway/config

    # auto start config (zprofile)
    if [[ -f /home/$LOGNAME/.zprofile ]]; then
        SWAY_IN_ZPROFILE=$(cat /home/$LOGNAME/.zprofile | grep sway)
        if [[ ! $SWAY_IN_ZPROFILE =~ "sway" ]]; then
            cat dotfiles/15_sway_zprofile >> /home/$LOGNAME/.zprofile
        fi
    else
        cat dotfiles/15_sway_zprofile >> /home/$LOGNAME/.zprofile
    fi

    # kitty config
    rm -rf /home/$LOGNAME/.config/kitty
    mkdir /home/$LOGNAME/.config/kitty
    cp dotfiles/20_kitty.conf /home/$LOGNAME/.config/kitty/kitty.conf
    # download the dracula.conf and diff.conf
    wget https://raw.githubusercontent.com/dracula/kitty/master/dracula.conf
    mv dracula.conf /home/$LOGNAME/.config/kitty/dracula.conf
    wget https://raw.githubusercontent.com/dracula/kitty/master/diff.conf
    mv diff.conf /home/$LOGNAME/.config/kitty/diff.conf

    # waybar config
    rm -rf /home/$LOGNAME/.config/waybar
    mkdir /home/$LOGNAME/.config/waybar
    cp dotfiles/30_waybar_config /home/$LOGNAME/.config/waybar/config
    cp dotfiles/31_waybar_style.css /home/$LOGNAME/.config/waybar/style.css

    # wofi config
    rm -rf /home/$LOGNAME/.config/wofi
    mkdir /home/$LOGNAME/.config/wofi
    cp dotfiles/35_wofi_style.css /home/$LOGNAME/.config/wofi/style.css
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
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
configure_sway
configure_keyring
post

