#!/bin/bash

set -e

LXQT_DIR=/home/$LOGNAME/.config/lxqt
OB_DIR=/home/$LOGNAME/.config/openbox
GLOBALKEY=$LXQT_DIR/globalkeyshortcuts.conf

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
    echo "Launch LxQt session config panel? (y/n)"
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

    sudo apt install -y \
        zathura \
        inxi \
        mpv \
        imv

    sudo apt install -y \
        sshfs
}

configure_scale(){
    # Add a new line
    echo '' >> $LXQT_DIR/session.conf

    # Change global screen scaling to factor 1.10
    # ~/.config/lxqt/session.conf => QT_SCALE_FACTOR=1.10
    term_color_red
    echo "Update the Global Screen Scaling value"
    term_color_white

    echo -e '[Environment]' >> $LXQT_DIR/session.conf

    MY_GDK=$(cat $LXQT_DIR/session.conf | grep GDK_SCALE | wc -l)
    if [[ $MY_GDK == '0' ]]; then
        echo 'GDK_SCALE=1.10' >> $LXQT_DIR/session.conf
    fi

    MY_QT=$(cat $LXQT_DIR/session.conf | grep QT_SCALE_FACTOR | wc -l)
    if [[ $MY_QT == '0' ]]; then
        echo 'QT_SCALE_FACTOR=1.10' >> $LXQT_DIR/session.conf
    fi
}

configure_trackpad(){
    # Add a new line
    echo '' >> $LXQT_DIR/session.conf

    # Skip if there is no touchpad
    TOUCHPAD_EXISTS=$(xinput --list --name-only | grep Touchpad)
    if [[ TOUCHPAD_EXISTS == "0" ]]; then
        return 0 # don't use other numbers...
    fi

    # Enable trackpad's
    # 1. Tap to click
    # 2. Natural scrolling
    # 3. Tap and drag
    term_color_red
    echo "Update the touchpad config"
    term_color_white

    echo -e '[Touchpad]' >> $LXQT_DIR/session.conf

    # In case of Wayland
    # sudo libinput list-devices | grep Touchpad
    TOUCHPAD_NAME=$(xinput --list --name-only | grep Touchpad | sed 's/ /%2520/g' | sed 's/:/%253A/g')
    echo $TOUCHPAD_NAME'\tappingEnabled=1' >> $LXQT_DIR/session.conf
    echo $TOUCHPAD_NAME'\naturalScrollingEnabled=1' >> $LXQT_DIR/session.conf
    echo $TOUCHPAD_NAME'\tapToDragEnabled=1' >> $LXQT_DIR/session.conf
}

configure_no_idle(){
    # Disable Idleness Watcher
    term_color_red
    echo "No idle watcher"
    term_color_white

    WATCHER_ENABLED=$(cat $LXQT_DIR/lxqt-powermanagement.conf | grep enableIdlenessWatcher | wc -l)
    if [[ ! $WATCHER_ENABLED == "0" ]]; then
        sed -i 's/enableIdlenessWatcher=true/enableIdlenessWatcher=false/' $LXQT_DIR/lxqt-powermanagement.conf
    else
        echo 'enableIdlenessWatcher=false' >> $LXQT_DIR/lxqt-powermanagement.conf
    fi
}

configure_openbox(){
    term_color_red
    echo "Update Openbox config"
    term_color_white

    # Re-generate the rc.xml.
    # This rc.xml is not the same with /etc/xdg/openbox/rc.xml.
    rm -rf $OB_DIR
    mkdir -p $OB_DIR
    obconf-qt &
    sleep 1
    killall obconf-qt

    # Change Sweep up/down for desktop switching to nothing
    # (Be careful for the XML namespace when using xmlstarlet)
    xmlstarlet ed --inplace \
      -N o="http://openbox.org/3.4/rc" \
      -u '//o:openbox_config/o:mouse/o:context[@name="Desktop"]/o:mousebind[@button="Up" and @action="Click"]/o:action[@name="GoToDesktop"]/o:to' \
      -v "" $OB_DIR/rc.xml
    xmlstarlet ed --inplace \
      -N o="http://openbox.org/3.4/rc" \
      -u '//o:openbox_config/o:mouse/o:context[@name="Desktop"]/o:mousebind[@button="Down" and @action="Click"]/o:action[@name="GoToDesktop"]/o:to' \
      -v "" $OB_DIR/rc.xml

    # Switch to left desktop: Meta+Alt+i
    # Switch to right desktop: Meta+Alt+o
    sed -i 's/C-A-Left/W-i/' $OB_DIR/rc.xml
    sed -i 's/C-A-Right/W-o/' $OB_DIR/rc.xml

    # Move the current window to left desktop: Meta+Control+i
    # Move the current window to right desktop: Meta+Control+o
    sed -i 's/C-S-A-Left/W-A-i/' $OB_DIR/rc.xml
    sed -i 's/C-S-A-Right/W-A-o/' $OB_DIR/rc.xml

    # Toggle full screen
    sed -i 's/F11/W-Up/' $OB_DIR/rc.xml

    # Close the current window
    sed -i 's/A-F4/W-S-q/' $OB_DIR/rc.xml
}


configure_lxqt_shortcuts(){
    term_color_red
    echo "Configure LxQt shortcuts"
    term_color_white

    # Replace Super_L with Meta+Esc
    sed -i 's/Super_L/Meta%2BEscape/' $GLOBALKEY

    # Open terminal: Meta+Return
    echo -e "[Meta%2BReturn]\nComment=Terminal\nEnabled=True\nExec=qterminal\n" >> \
        $GLOBALKEY

    # Open LxQt Configuration Center: Meta+g
    echo -e "[Meta%2BG]\nComment=Config-center\nEnabled=True\nExec=lxqt-config\n" >> \
        $GLOBALKEY

    # Open File browser: Meta+t
    echo -e "[Meta%2BT]\nComment=PcmanFM\nEnabled=True\nExec=pcmanfm-qt\n" >> \
        $GLOBALKEY

    # Open Chrome: Meta+y
    echo -e "[Meta%2BY]\nComment=Chrome\nEnabled=True\nExec=google-chrome\n" >> \
        $GLOBALKEY

    # Open Code: Meta+u
    echo -e "[Meta%2BU]\nComment=Code\nEnabled=True\nExec=code\n" >> \
        $GLOBALKEY

    # Open Zathura: Meta+z
    echo -e "[Meta%2BZ]\nComment=Zathura\nEnabled=True\nExec=zathura\n" >> \
        $GLOBALKEY

    # Switch to screen 1: Meta+1
    sed -i 's/Control%2BF1/Meta%2B1/' $GLOBALKEY

    # Switch to screen 2: Meta+2
    sed -i 's/Control%2BF2/Meta%2B2/' $GLOBALKEY

    # Switch to screen 3: Meta+3
    sed -i 's/Control%2BF3/Meta%2B3/' $GLOBALKEY

    # Switch to screen 4: Meta+4
    sed -i 's/Control%2BF4/Meta%2B4/' $GLOBALKEY

    # Control screen brightness: Meta+Alt+1
    echo -e "[Meta%2BAlt%2B1]\nComment=Open brightness control\nEnabled=True\nExec=lxqt-config-brighness\n" >> \
        $GLOBALKEY

    # Decrease volume: Meta+Alt+8
    sed -i 's/XF86AudioLowerVolume/Alt%2BMeta%2B8/' $GLOBALKEY

    # Increase volume: Meta+Alt+9
    sed -i 's/XF86AudioRaiseVolume/Alt%2BMeta%2B9/' $GLOBALKEY

    # Mute: Meta+Alt+0
    sed -i 's/XF86AudioMute/Alt%2BMeta%2B0/' $GLOBALKEY

    # LXQt leave: Meta+Alt+l
    echo -e "[Meta%2BAlt%2BL]\nComment=Screen lock\nEnabled=True\nExec=lxqt-leave\n" >> \
        $GLOBALKEY
}

post (){
    term_color_red
    echo "Done"
    echo "- Change Global Screen Scale"
    echo "- Change Trackpad direction and tapping behavior"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
configure_scale
configure_trackpad
configure_no_idle
configure_openbox
configure_lxqt_shortcuts
post

