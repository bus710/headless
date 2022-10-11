#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo -e "\e[91m"
echo "This script does:"
echo "- Add some auto start configs for XFCE4 session"
echo "- Make auto-login for the current user (${USER})"
echo "- So on start up, auto login, synergy client starts, but screen will be locked"
echo
echo "Do you want to install? (y/n)"
echo -e "\e[39m"

if [[ ! $XDG_CURRENT_DESKTOP =~ "XFCE" ]]; then
    echo
    echo "Not XFCE."
    echo
    exit

elif [[ $XDG_CURRENT_DESKTOP =~ "XFCE" ]]; then
    echo
    echo "Home directory cleanup."
    echo

    # Add Synergy auto start
    SYNERGY_DESKTOP="/home/$LOGNAME/.config/autostart/synergy.desktop" 
    if [[ ! -d ~/.config/autostart ]]; then
      mkdir ~/.config/autostart -p
    fi
    rm -rf $SYNERGY_DESKTOP
    echo "[Desktop Entry]" >> $SYNERGY_DESKTOP
    echo "Type=Application" >> $SYNERGY_DESKTOP
    echo "Name=synergy" >> $SYNERGY_DESKTOP
    echo "Exec=/usr/bin/synergy" >> $SYNERGY_DESKTOP

    # Add dm-tool-lock auto start
    DM_TOOL_LOCK_DESKTOP="/home/$LOGNAME/.config/autostart/dm-tool-lock.desktop" 
    if [[ ! -d ~/.config/autostart ]]; then
      mkdir ~/.config/autostart -p
    fi
    rm -rf $DM_TOOL_LOCK_DESKTOP
    echo "[Desktop Entry]" >> $DM_TOOL_LOCK_DESKTOP
    echo "Type=Application" >> $DM_TOOL_LOCK_DESKTOP
    echo "Name=dm-tool-lock" >> $DM_TOOL_LOCK_DESKTOP
    echo "Exec=dm-tool lock" >> $DM_TOOL_LOCK_DESKTOP

    # Make auto login for the current user 
    AUTO_LOGIN="/etc/lightdm/lightdm.conf.d/50-auto.conf"
    if [[ ! -d /etc/lightdm/lightdm.conf.d ]]; then
        sudo mkdir /etc/lightdm/lightdm.conf.d 
    fi
    sudo rm -rf $AUTO_LOGIN
    sudo bash -c "echo '[Seat:*]' >> $AUTO_LOGIN"
    sudo bash -c "echo 'autologin-user=$USER' >> $AUTO_LOGIN"
    sudo bash -c "echo 'autologin-user-timeout=0' >> $AUTO_LOGIN" 

    echo 
    echo "Done"
    echo
fi

echo
echo "Done"
echo
