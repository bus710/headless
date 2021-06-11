#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

SLACK_VER="slack-desktop-4.12.2-amd64.deb"
ZOOM_VER="zoom_amd64.deb"

wget https://downloads.slack-edge.com/linux_releases/$SLACK_VER
sudo dpkg -i $SLACK_VER
rm -rf $SLACK_VER

sudo apt install -y \
    libgl1-mesa-glx \
    libegl1-mesa \
    libxcb-xtest0

wget https://zoom.us/client/latest/$ZOOM_VER
sudo dpkg -i $ZOOM_VER
rm -rf $ZOOM_VER

echo
echo "Done"
echo
