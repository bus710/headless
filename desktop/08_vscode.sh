#!/bin/bash

# Preferred font size - 17

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo "Install"
echo "- visual studio code and code-insider"
echo

echo
echo -e "\e[91m"
echo "Please check the website if there is a newer version"
echo "- https://github.com/microsoft/vscode/releases"
echo 
echo "Do you want to install? (y/n)"
echo -e "\e[39m"
echo

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]
then
    echo 
    echo "Add repo"
    echo 

    cd ~/Downloads
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    echo
    echo "Install Vsode"
    echo

    sudo apt install -y apt-transport-https
    sudo apt update -y
    sudo apt install -y code 
    #sudo apt install -y code-insiders

    rm -rf *.gpg
fi
