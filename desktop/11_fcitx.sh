#!/bin/bash

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

sudo apt install -y \
    fcitx \
    fcitx-config-gtk \
    fcitx-hangul

im-config -n fcitx

sudo bash -c 'echo "GTK_IM_MODULE=fcitx" >> /etc/environment'
sudo bash -c 'echo "QT_IM_MODULE=fcitx" >> /etc/environment'
sudo bash -c 'echo "XMODIFIERS=@im=fcitx" >> /etc/environment'

echo
echo "Done!"
echo "- add /usr/bin/fcitx to Startup Applications"
echo "- reboot and run fcitx-config-gtk3"
echo "- also, install the korean support in settings - language/method"
echo
