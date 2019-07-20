#!/bin/bash

VERSION="go1.12.7.linux-amd64.tar.gz"

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

echo
echo "Please check the website if there is a newer version"
echo "https://golang.org/dl/"
echo 
echo "$VERSION will be installed"
echo "/usr/local/bin and ~/go will be deleted"
echo 
echo "Do you want to install? (y/n)"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then
    # Get logname first (this is not $USER)
    LOGNAME="$(logname)"

    echo 
    echo "Existing Go directories will be deleted"
    echo 

    rm -rf /usr/local/go
    rm -rf /home/$LOGNAME/go

    mkdir -p /usr/local/go
    mkdir /home/$LOGNAME/go
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/go

    echo
    echo "Download and install Go SDK"
    echo 

    rm go*.tar.gz*
    wget https://dl.google.com/go/$VERSION

    echo
    echo "Wait for untar..."
    echo

    tar -xf go*.tar.gz --strip-components=1 -C /usr/local/go
    rm go*.tar.gz

    echo 
    echo "1. Please install Delve:"
    echo "  go get -u github.com/go-delve/delve/cmd/dlv"
    echo 
    echo "2. Please run this in nvim:"
    echo "  :GoInstallBinaries"
    echo 
fi
