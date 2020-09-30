#!/bin/bash

set -e

cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si # this installs system level golang
yay # to update index
cd 
rm -rf yay
