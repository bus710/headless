#!/bin/bash

set -e

CPU_TYPE=$(uname -m)
CPU_TARGET=""

if [[ $CPU_TYPE == "x86_64" ]]; then
    CPU_TARGET="amd64" 
elif [[ $CPU_TYPE == "aarch64" ]]; then
    CPU_TARGET="arm64"
    echo "Not supported architecture"
else
    echo "Not supported architecture"
    exit
fi

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

VERSION=$(curl --silent https://github.com/elm/compiler/releases/latest \
    | grep -oP '(?<=/tag\/)[^">]+')

echo
echo -e "\e[91m"
echo "Please check the website if there is a newer version"
echo "- https://github.com/elm/compiler/releases"
echo 
echo "$VERSION will be installed"
echo "/usr/local/elm will be deleted"
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
    echo "Existing Elm directory will be deleted"
    echo 

    sudo bash -c "rm -rf /usr/local/elm"
    sudo bash -c "mkdir -p /usr/local/elm"

    echo
    echo "Download and install Elm compiler"
    echo 

    curl --silent https://github.com/elm/compiler/releases/latest \
        | grep -oP '(?<=/tag\/)[^">]+' \
        | xargs -I '{}' curl -L -o elm.gz https://github.com/elm/compiler/releases/download/'{}'/binary-for-linux-64-bit.gz

    echo
    echo "Wait for unzip..."
    echo

    gunzip elm.gz
    
    echo
    echo "Move compiler to /usr/local/elm"
    echo

    chmod 760 elm
    sudo mv elm /usr/local/elm

    echo 
    echo "Install Elm linter and test packages"
    echo

    sudo npm install -g elm-test 
    sudo npm install -g elm-json
    sudo npm install -g elm-live
    sudo npm install -g elm-format
    sudo npm install -g elm-analyse
    sudo npm install -g create-elm-app

    echo 
    echo "Done - don't forget to have PATH of Elm"
    echo
fi
