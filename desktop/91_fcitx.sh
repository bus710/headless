#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

echo
echo "Install language packs and fonts"
echo 

#sudo apt install -y \
#    language-pack-gnome-ko \
#    language-pack-gnome-en

sudo apt install -y \
    fonts-nanum \
    fonts-nanum-coding \
    fonts-noto-cjk 

echo
echo "Install fcitx"
echo

sudo apt install -y \
    fcitx-config-gtk \
    fcitx-hangul \
    fcitx 

echo
echo "Set fcitx as IME of Gnome"
echo

im-config -n fcitx

echo
echo "Set required Wayland global variables"
echo

sudo bash -c 'echo "GTK_IM_MODULE=fcitx" >> /etc/environment'
sudo bash -c 'echo "QT_IM_MODULE=fcitx" >> /etc/environment'
sudo bash -c 'echo "XMODIFIERS=@im=fcitx" >> /etc/environment'

echo
echo "Add fcitx as startup app"
echo

FCITX_DESKTOP="/home/$LOGNAME/.config/autostart/fcitx.desktop" 
if [[ ! -d ~/.config/autostart ]]; then
    mkdir ~/.config/autostart -p
fi
rm -rf $FCITX_DESKTOP
echo "[Desktop Entry]" >> $FCITX_DESKTOP
echo "Type=Application" >> $FCITX_DESKTOP
echo "Name=fcitx" >> $FCITX_DESKTOP
echo "Exec=/usr/bin/fcitx" >> $FCITX_DESKTOP

echo
echo "Done!"
echo "- add /usr/bin/fcitx to Startup Applications"
echo "- reboot and run fcitx-config-gtk3"
echo "- also, install the korean support in settings - language/method"
echo

