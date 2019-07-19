#!/bin/bash

VERSION="go1.12.7.linux-amd64.tar.gz"

sudo rm -rf /usr/local/go
sudo mkdir -p /usr/local/go
rm -rf ~/go
mkdir ~/go

wget https://dl.google.com/go/$VERSION

echo
echo "Wait for untar"
echo

sudo tar -xf $VERSION --strip-components=1 -C /usr/local/go
rm $VERSION

echo 
echo "Install Delve"
echo 

go get -u github.com/derekparker/delve/cmd/dlv

echo 
echo
go version
echo
dlv version
echo

