#!/bin/bash

VERSION="go1.12.7.linux-amd64.tar.gz"

echo
echo "Please check the website if there is a newer version"
echo "https://golang.org/dl/"
echo 
echo "$VERSION will be installed"
echo 
echo "Do you want to install? (y/n)"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then
    echo 
    echo "Existing Go directories will be deleted"
    echo 

    rm -rf /usr/local/go
    rm -rf ~/go

    mkdir -p /usr/local/go
    mkdir ~/go
    chown $USER:$USER ~/go

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
    echo "Please install Delve:"
    echo "go get -u github.com/go-delve/delve/cmd/dlv"
    echo 
fi
