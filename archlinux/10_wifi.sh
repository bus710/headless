#!/bin/bash

sudo systemctl stop dhcpcd.service
sudo systemctl disable dhcpcd.service
sudo systemctl stop iwd.service
sudo systemctl disable iwd.service

sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

nmcli radio wifi on
nmcli device wifi list

echo
echo "nmcli device wifi connect SSID password PASSWORD"
echo
