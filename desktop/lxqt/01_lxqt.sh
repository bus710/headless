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

    term_color_red
    echo "Configure LxQt shortcuts"
    term_color_white

    # Change global screen scaling to factor 1.25

    # Change Sweep up/down for desktop switching to nothing

    # Enable trackpad tap to click
    # Enable trackpad natural scrolling
    # Enable trackpad tap and drag

    # Disable Idleness Watcher

    # Open terminal: Meta+Return
    # Open LxQt Configuration Center: Meta+g
    # Open File browser: Meta+t
    # Open Chrome: Meta+y
    # Open Code: Meta+u
    # Open Zathura: Meta+z
    # Close the current window: Meta+Shift+q

    # Switch to screen 1: Meta+1
    # Switch to screen 2: Meta+2
    # Switch to screen 3: Meta+3
    # Switch to screen 4: Meta+4
    # Switch to left desktop: Meta+i
    # Switch to right desktop: Meta+o
    # Move the current window to left desktop: Meta+Alt+i
    # Move the current window to right desktop: Meta+Alt+o

    # Lower screen brightness: Meta+Alt+1
    # Higher screen brightness: Meta+Alt+2
    # Lower volume: Meta+Alt+8
    # Lower volume: Meta+Alt+9
    # Mute: Meta+Alt+0
    # Screen lock: Meta+Alt+l
    # Power off: Meta+Alt+k

    # Replace CapsLock to Ctrl
    # Default Font for user interface => Point Size: 12
    # Wallpaper image file:
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

