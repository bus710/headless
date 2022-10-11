#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "Install snapd and snap packages"
echo

sudo apt install -y snapd

# Classic
#sudo snap install --classic goland
sudo snap install --classic slack
sudo snap install --beta sqlitebrowser

# Not classic
sudo snap install mqtt-explorer

