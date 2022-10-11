#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

# Installing GUI applications required.

echo
echo "Install"
echo "- Vim-gnome"
echo "- Gnome Tweak Tools"
echo "- Simple Screen Recorder"
echo

sudo apt install -y \
    solaar \
    vim-gtk3 \
    simplescreenrecorder \
    pinta

echo
echo "Done"
echo 
