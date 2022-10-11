#!/bin/bash

set -e

CPU_TYPE=$(uname -m)
CPU_TARGET=""

if [[ $CPU_TYPE == "x86_64" ]]; then
    CPU_TARGET="amd64" 
elif [[ $CPU_TYPE == "aarch64" ]]; then
    CPU_TARGET="arm64"
else
    exit
fi

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "Svelte, degit, and other tools will be installed"
echo "Do you want to install? (y/n)"
echo -e "\e[39m"
echo

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]
then
    echo 
    echo
    echo

    npm -v

    sudo npm install -g degit
    sudo npm install -g svelte-language-server

    echo 
    echo "Done"
    echo
fi
