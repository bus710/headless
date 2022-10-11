#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

sudo apt install -y libgconf-2-4 libc++1

URL="https://discord.com/api/download?platform=linux&format=deb"
FILE_NAME="discord.deb"

wget $URL -O $FILE_NAME
sudo dpkg -i $FILE_NAME
rm -rf $FILE_NAME

echo
echo "Done"
echo
