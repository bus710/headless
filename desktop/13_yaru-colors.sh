#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

sudo apt install -y \
    dconf-cli

git clone https://github.com/Jannomag/Yaru-Colors
cd Yaru-Colors
./install.sh
cd ..
rm -rf Yaru-Colors
