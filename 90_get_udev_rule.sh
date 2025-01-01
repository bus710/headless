#!/bin/bash

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

# Check the mac address of the card
WLP=$(ls /sys/class/net | grep wl)
MAC=$(cat /sys/class/net/$WLP/address)
NAME="wlan0"

term_color_red
echo "Use the command below to set the udev rule:"
term_color_white

echo "sudo tee /etc/udev/rules.d/70-persistent-net.rules <<EOF"
echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$MAC\", ATTR{dev_id}==\"0x0\", ATTR{type}==\"1\", KERNEL==\"wlan*\", NAME=\"$NAME\""
echo "EOF"

echo
