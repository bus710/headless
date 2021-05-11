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

VERSION="go1.15.6.linux-$CPU_TARGET.tar.gz"

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "Please check the website if there is a newer version"
echo "- https://golang.org/dl/"
echo 
echo "$VERSION will be installed"
echo "/usr/local/go and ~/go will be deleted"
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
    echo "Existing Go directories will be deleted"
    echo 

    sudo bash -c "rm -rf /usr/local/go"
    rm -rf /home/$LOGNAME/go

    sudo bash -c "mkdir -p /usr/local/go"
    mkdir /home/$LOGNAME/go
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/go

    echo
    echo "Download and install Go SDK"
    echo 

    # Remove if there is old tarballs
    echo
    rm -rf go*.tar.gz*
    echo

    wget https://dl.google.com/go/$VERSION

    echo
    echo "Wait for untar..."
    echo

    sudo bash -c "tar -xf go*.tar.gz --strip-components=1 -C /usr/local/go"
    rm -rf go*.tar.gz

    echo 
    echo "Done"
    echo
fi
