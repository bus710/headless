#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "Install snapd and vscode"
echo

sudo apt install -y snapd

# Classic
#sudo snap install --classic goland
sudo snap install --classic snapcraft
sudo snap install --classic code 
sudo snap install --classic code-insiders 

