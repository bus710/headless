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
        xdotool \
        zathura \
        inxi \
        mpv \
        imv

    sudo apt install -y \
        sshfs
}

configure_lxqt_session_and_appearance(){
    term_color_red
    echo "Configure LxQt session and appearance"
    term_color_white

    # Change global screen scaling to factor 1.10
    # ~/.config/lxqt/session.conf => QT_SCALE_FACTOR=1.10
    term_color_red
    echo "Update the Global Screen Scaling value"
    term_color_white

    MY_GDK=$(cat $LXQT_DIR/session.conf | grep GDK_SCALE | wc -l)
    if [[ $MY_GDK == '0' ]]; then
        echo 'GDK_SCALE=1.10' >> $LXQT_DIR/session.conf
    fi

    MY_QT=$(cat $LXQT_DIR/session.conf | grep QT_SCALE_FACTOR | wc -l)
    if [[ $MY_QT == '0' ]]; then
        echo 'QT_SCALE_FACTOR=1.10' >> $LXQT_DIR/session.conf
    fi

    # Enable trackpad's
    # 1. Tap to click
    # 2. Natural scrolling
    # 3. Tap and drag
    term_color_red
    echo "Update the touchpad config"
    term_color_white

    # In case of Wayland
    # sudo libinput list-devices | grep Touchpad
    TOUCHPAD_NAME=$(xinput --list --name-only | grep Touchpad | sed 's/ /%2520/g' | sed 's/:/%253A/g')
    echo $TOUCHPAD_NAME'\\tappingEnabled=1' >> $LXQT_DIR/session.conf
    echo $TOUCHPAD_NAME'\\naturalScrollingEnabled=1' >> $LXQT_DIR/session.conf
    echo $TOUCHPAD_NAME'\\tapToDragEnabled=1' >> $LXQT_DIR/session.conf

    # Disable Idleness Watcher
    term_color_red
    echo "No idle watcher"
    term_color_white

    echo 'enableIdlenessWatcher=false' >> $LXQT_DIR/lxqt-powermanagement.conf

    # Replace CapsLock to Ctrl (Done by another script)
    # sudo bash -c "echo 'XKBOPTIONS=ctrl:nocaps' >> /etc/default/keyboard"
    # setupcon -k

    # Wallpaper image file:
    # WiP
}

configure_openbox(){
    term_color_red
    echo "Update Openbox config"
    term_color_white

    rm -rf $OB_DIR
    sudo cp /etc/xdg/openbox/rc.xml $OB_DIR
    sudo chown $LOGNAME:$LOGNAME $OB_DIR/rc.xml
    chmod 664 $OB_DIR/rc.xml

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
    echo -e "[Meta%2BY]\nComment=Chrome\nEnabled=True\nExec=google-chrome-stable\n" >> \
        $GLOBALKEY

    # Open Code: Meta+u
    echo -e "[Meta%2BU]\nComment=Code\nEnabled=True\nExec=code\n" >> \
        $GLOBALKEY

    # Open Zathura: Meta+z
    echo -e "[Meta%2BZ]\nComment=Zathura\nEnabled=True\nExec=zathura\n" >> \
        $GLOBALKEY

    # Close the current window: Meta+Shift+q
    echo -e "[Shift%2BMeta%2BQ]\nComment=Close\nEnabled=True\nExec=xdotool, getwindowfocus, windowkill\n" >> \
        $GLOBALKEY

    # Switch to screen 1: Meta+1
    sed -i 's/\/panel\/taskbar\/task_1/\/panel\/desktopswitch\/desktop_1/' $GLOBALKEY

    # Switch to screen 2: Meta+2
    sed -i 's/\/panel\/taskbar\/task_2/\/panel\/desktopswitch\/desktop_2/' $GLOBALKEY

    # Switch to screen 3: Meta+3
    sed -i 's/\/panel\/taskbar\/task_3/\/panel\/desktopswitch\/desktop_3/' $GLOBALKEY

    # Switch to screen 4: Meta+4
    sed -i 's/\/panel\/taskbar\/task_4/\/panel\/desktopswitch\/desktop_4/' $GLOBALKEY

    # Decrease screen brightness: Meta+Alt+1
    echo -e "[Meta%2BAlt%2B1]\nComment=Brightness down\nEnabled=True\nlxqt-config-brightness, -d\n" >> \
        $GLOBALKEY

    # Increase screen brightness: Meta+Alt+2
    echo -e "[Meta%2BAlt%2B2]\nComment=Brightness up\nEnabled=True\nlxqt-config-brightness, -i\n" >> \
        $GLOBALKEY

    # Decrease volume: Meta+Alt+8
    echo -e "[Meta%2BAlt%2B8]\nComment=Decrease volume\nEnabled=True\npath=/panel/volume/down\n" >> \
        $GLOBALKEY

    # Increase volume: Meta+Alt+9
    echo -e "[Meta%2BAlt%2B9]\nComment=Increase volume\nEnabled=True\npath=/panel/volume/up\n" >> \
        $GLOBALKEY

    # Mute: Meta+Alt+0
    echo -e "[Meta%2BAlt%2B0]\nComment=Mute volume\nEnabled=True\npath=/panel/volume/mute\n" >> \
        $GLOBALKEY

    # Screen lock: Meta+Alt+l
    echo -e "[Meta%2BAlt%2BL]\nComment=Screen lock\nEnabled=True\nExec=lxqt-leave\n" >> \
        $GLOBALKEY

    # Power off: Meta+Alt+k
    echo -e "[Meta%2BAlt%2BK]\nComment=Screen lock\nEnabled=True\nExec=lxqt-leave\n" >> \
        $GLOBALKEY
}

post (){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
configure_lxqt_session_and_appearance
configure_openbox
configure_lxqt_shortcuts
post

