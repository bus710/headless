#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
    exit
fi

if [[ ! $XDG_CURRENT_DESKTOP =~ "GNOME" ]]; then
    term_color_red
    echo
    echo "Not Gnome"
    echo
    term_color_white

    exit
fi

echo
echo "Install"
echo "- Vim-gnome"
echo "- Pinta"
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
