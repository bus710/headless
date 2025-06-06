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
    echo "Configure Gnome Keyring? (y/n)"
    term_color_white
    
    echo
    read -n 1 ans
    echo
    
    if [[ ! $ans == "y" ]]; then
        echo
        exit 1
    fi
}

install_packages (){
    term_color_red
    echo "Install packages"
    term_color_white

    sudo apt install -y \
        seahorse
}

configure_keyring (){
    term_color_red
    echo "Configure Gnome keyring manager"
    term_color_white

    rm -rf /home/$LOGNAME/.config/systemd/user/gnome-keyring-daemon.service
    mkdir -p /home/$LOGNAME/.config/systemd/user/
    cp /usr/lib/systemd/user/gnome-keyring-daemon.service \
        /home/$LOGNAME/.config/systemd/user/

    sed -i 's/,secrets/,secrets,ssh/g' /home/$LOGNAME/.config/systemd/user/gnome-keyring-daemon.service

    sed -i 's/graphical-session-pre.target/default.target/g' /home/$LOGNAME/.config/systemd/user/gnome-keyring-daemon.service

    term_color_red
    echo "Load Gnome keyring manager"
    term_color_white

    systemctl disable --user gnome-keyring-daemon
    systemctl daemon-reload --user
    systemctl enable --now --user gnome-keyring-daemon
    systemctl status --user gnome-keyring-daemon --no-pager | grep -A2 CGroup

    # The port can be 1000 or something else.
    # Or add "export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh" to .zshrc
    sed -i '/#SSH_AUTH_SOCK/c\export SSH_AUTH_SOCK=\/run\/user\/1000\/keyring\/ssh' /home/$LOGNAME/.shrc
}

post (){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
configure_keyring
post

