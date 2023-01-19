#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

ZOOM_VER="zoom_amd64.deb"

sudo apt install -y \
    libgl1-mesa-glx \
    libegl1-mesa \
    libxcb-xtest0

wget https://zoom.us/client/latest/$ZOOM_VER \
    -O /home/$LOGNAME/Downloads/$ZOOM_VER
cd /home/$LOGNAME/Downloads
sudo dpkg -i $ZOOM_VER
rm -rf $ZOOM_VER

echo
echo "Done"
echo
