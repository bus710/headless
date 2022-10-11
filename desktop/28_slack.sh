#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

VER="4.22.0"
SLACK_VER="slack-desktop-${VER}-amd64.deb"
URL=https://downloads.slack-edge.com/releases/linux/${VER}/prod/x64/${SLACK_VER}

wget $URL
sudo dpkg -i $SLACK_VER
rm -rf $SLACK_VER

echo
echo "Done"
echo
