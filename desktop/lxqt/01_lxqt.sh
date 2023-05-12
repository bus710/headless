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
    echo
    echo "Install and configure LxQt? (y/n)"
    echo
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo
        exit -1
    fi

    sudo echo
}

install_packages(){
    term_color_red
    echo "Install some packages"
    term_color_white

    # Extra apps and theming
    sudo apt install -y \
        zathura \
        inxi \
        mpv \
        imv

    # Auth
    sudo apt install -y \
        sshfs

    # End of function for bash formatter
}

configure_lxqt(){
    term_color_red
    echo "Configure LxQt"
    term_color_white

    rm -rf /home/$LOGNAME/Downloads
    mkdir /home/$LOGNAME/Downloads
}

post (){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
configure_lxqt
post

