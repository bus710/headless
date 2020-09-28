#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

if [[ $XDG_CURRENT_DESKTOP =~ "ubuntu:GNOME" ]]; then
    sudo apt install -y \
        dconf-cli

    git clone https://github.com/Jannomag/Yaru-Colors
    cd Yaru-Colors
    ./install.sh
    cd ..
    rm -rf Yaru-Colors
fi



