#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

if [[ $XDG_CURRENT_DESKTOP =~ "ubuntu:GNOME" ]]; then
    sudo apt install -y \
        chrome-gnome-shell
fi

echo 
echo "Install Chrome Browser"
echo 

URL="https://dl.google.com/linux/direct/"
PACKAGE_NAME="google-chrome-stable_current_amd64.deb"

cd ~/Downloads
wget ${URL}${PACKAGE_NAME}
sudo dpkg -i ${PACKAGE_NAME}
rm ${PACKAGE_NAME}

echo
echo "Done"
echo "- Enable chrome://flags/#enable-webrtc-pipewire-capturer for Google Meet screen sharing in SwayWM"
echo 
