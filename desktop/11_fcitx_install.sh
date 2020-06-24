#!/bin/bash

sudo apt install fcitx fcitx-config-gtk fcitx-hangul
im-config -n fcitx

echo
echo "Done!"
echo "	- reboot and run fcitx-config-gtk3"
echo "	- also, install the korean support in settings - language/method"
echo
