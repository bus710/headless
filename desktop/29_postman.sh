#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

sudo echo "" # to get sudo power

POSTMAN_VER="postman_latest.tar.gz"

# Download and untar 
sudo rm -rf /usr/share/Postman
cd /usr/share
sudo wget https://dl.pstmn.io/download/latest/linux64 -O $POSTMAN_VER
sudo tar xvf $POSTMAN_VER
sudo rm -rf $POSTMAN_VER

# Register 
cd /usr/bin
sudo ln -s /usr/share/Postman/Postman postman

# Create a shortcut
cd ~/.local/share/applications
rm -rf postman.desktop
touch postman.desktop

echo "[Desktop Entry]" >> postman.desktop
echo "Version=1.0" >> postman.desktop
echo "Type=Application" >> postman.desktop
echo "Name=Postman" >> postman.desktop
echo "Exec=/usr/share/Postman/Postman" >> postman.desktop
echo "Icon=/usr/share/Postman/app/resources/app/assets/icon.png" >> postman.desktop
echo "Categories=<list-of-;-separated-categories>" >> postman.desktop

echo
echo "Done"
echo
