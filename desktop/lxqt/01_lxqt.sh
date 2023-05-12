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
    # ~/.config/lxqt/session.conf => GDK_SCALE=1.25
    # ~/.config/lxqt/session.conf => QT_SCALE_FACTOR=1.25

    # Change default browser to Chrome
    # ~/.config/lxqt/session.conf => BROWSER=chrome

    # Change global font size to 12
    # ~/.config/lxqt/lxqt.conf => font="Ubuntu,12,-1,5..."

    # Change Sweep up/down for desktop switching to nothing
    # ~/.config/openbox/rc.xml
    # xmlstarlet ed --inplace \
    #   -N o="http://openbox.org/3.4/rc" \
    #   -u '//o:openbox_config/o:mouse/o:context[@name="Desktop"]/o:mousebind[@button="Up" and @action="Click"]/o:action[@name="GoToDesktop"]/o:to' \
    #   -v "" ~/.config/openbox/rc.xml
    # xmlstarlet ed --inplace \
    #   -N o="http://openbox.org/3.4/rc" \
    #   -u '//o:openbox_config/o:mouse/o:context[@name="Desktop"]/o:mousebind[@button="Down" and @action="Click"]/o:action[@name="GoToDesktop"]/o:to' \
    #   -v "" ~/.config/openbox/rc.xml

    # Enable trackpad tap to click
    # ~/.config/lxqt/session.conf => Touchpad\\tappingEnabled=1

    # Enable trackpad natural scrolling
    # ~/.config/lxqt/session.conf => Touchpad\\naturalScrollingEnabled=1

    # Enable trackpad tap and drag
    # ~/.config/lxqt/session.conf => Touchpad\\tapToDragEnabled=1

    # Disable Idleness Watcher
    # ~/.config/lxqt/lxqt-powermanagement.conf => enableIdlenessWatcher=false

    # Open terminal: Meta+Return
    # echo -e "[Meta%2BReturn]\nComment=Terminal\nEnabled=True\nExec=qterminal" >> \
    #   ~/.config/lxqt/lxqt-powermanagement.conf

    # Open LxQt Configuration Center: Meta+g
    # Open File browser: Meta+t
    # Open Chrome: Meta+y
    # Open Code: Meta+u
    # Open Zathura: Meta+z
    # Close the current window: Meta+Shift+q

    # Switch to screen 1: Meta+Alt+1
    # Switch to screen 2: Meta+Alt+2
    # Switch to screen 3: Meta+Alt+3
    # Switch to screen 4: Meta+Alt+4
    # Switch to left desktop: Meta+i
    # Switch to right desktop: Meta+o
    # Move the current window to left desktop: Meta+Alt+i
    # Move the current window to right desktop: Meta+Alt+o

    # Decrease screen brightness: Meta+Alt+1
    # Increase screen brightness: Meta+Alt+2
    # Decrease volume: Meta+Alt+8
    # Increase volume: Meta+Alt+9
    # Mute: Meta+Alt+0
    # Screen lock: Meta+Alt+l
    # Power off: Meta+Alt+k

    # Replace CapsLock to Ctrl
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

