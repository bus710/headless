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
         xorg-xwayland \
         xorg-xlsclients \
         qt5-wayland \
         glfw-wayland \
         libinput-tools

    # Audio
    sudo apt install -y \
         alsa-utils \
         pulseaudio \
         pulseaudio-alsa \
         pulseaudio-utils \
         pipewire-pulse \
         pavucontrol

    sudo usermod -aG audio $USERNAME

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
         imv
}

configure_sway (){
    term_color_red
    echo "Configure Sway"
    term_color_white

    $HOME/Downloads

    # sway config
    rm -rf $HOME/$LOGNAME/.config/sway/config
    cp dotfiles/10_sway_config $HOME/$LOGNAME/.config/sway/config

    # auto start config (zprofile)
    SWAY_IN_ZPROFILE=$(cat $HOME/$LOGNAME/.zprofile | grep sway)
    if [[ ! $SWAY_IN_ZPROFILE =~ "sway" ]]; then
        cat dotfiles/15_sway_zprofile >> $HOME/$LOGNAME/.zprofile
    fi

    # kitty config
    rm -rf $HOME/$LOGNAME/.config/kitty/config
    cp dotfiles/20_kitty.conf $HOME/$LOGNAME/.config/kitty/kitty.config
    # download the dracula.conf and diff.conf
    wget https://raw.githubusercontent.com/dracula/kitty/master/dracula.conf
    mv dracula.conf $HOME/$LOGNAME/.config/kitty/dracula.conf
    wget https://raw.githubusercontent.com/dracula/kitty/master/diff.conf
    mv diff.conf $HOME/$LOGNAME/.config/kitty/diff.conf

    # waybar config
    rm -rf $HOME/$LOGNAME/.config/waybar
    cp dotfiles/30_waybar_config $HOME/$LOGNAME/.config/waybar/config
    cp dotfiles/31_waybar_style.css $HOME/$LOGNAME/.config/waybar/style.css

    # wofi config
    rm -rf $HOME/$LOGNAME/.config/wofi
    cp dotfiles/35_wofi_style.css $HOME/$LOGNAME/.config/wofi/style.css
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
    echo "- Update the trackpad natural scrolling direction"
    echo "  - sudo libinput list-devices"
    echo "  - swaymsg -rt get_inputs"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
configure_sway
configure_keyring
post

