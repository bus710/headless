#!/bin/bash

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

# Check the mac address of the card
ENO=$(ls /sys/class/net | grep eno)

if [[ $(cat $ENO | wc -m) =~ 0 ]]; then
    ENO_MAC=$(cat /sys/class/net/$ENO/address)
    ENO_NAME="eth0"

    term_color_red
    echo "Use the command below to set the udev rule for eth0:"
    term_color_white

    echo "sudo tee /etc/udev/rules.d/70-persistent-net.rules <<EOF"
    echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$ENO_MAC\", ATTR{dev_id}==\"0x0\", ATTR{type}==\"1\", KERNEL==\"eth*\", NAME=\"$ENO_NAME\""
    echo "EOF"
fi

WLP=$(ls /sys/class/net | grep wl)

if [[ $(echo $WLP | wc -m) =~ 0 ]]; then
    WLP_MAC=$(cat /sys/class/net/$WLP/address)
    WLP_NAME="wlan0"

    term_color_red
    echo "Use the command below to set the udev rule for wlan0:"
    term_color_white

    echo "sudo tee /etc/udev/rules.d/70-persistent-net.rules <<EOF"
    echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$WLP_MAC\", ATTR{dev_id}==\"0x0\", ATTR{type}==\"1\", KERNEL==\"wlan*\", NAME=\"$WLP_NAME\""
    echo "EOF"
fi
echo
