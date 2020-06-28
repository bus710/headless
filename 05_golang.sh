#!/bin/bash

CPU_TYPE=$(uname -p)
CPU_TARGET=""

if [[ $CPU_TYPE == "x86_64" ]]; then
    CPU_TARGET="amd64" 
elif [[ $CPU_TYPE == "aarch64" ]]; then
    CPU_TARGET="arm64"
else
    exit
fi

VERSION="go1.14.4.linux-$CPU_TARGET.tar.gz"

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "Please check the website if there is a newer version"
echo "- https://golang.org/dl/"
echo 
echo "$VERSION will be installed"
echo "/usr/local/bin and ~/go will be deleted"
echo 
echo "Do you want to install? (y/n)"
echo -e "\e[39m"
echo
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

    # Remove if there is old tarballs
    rm go*.tar.gz*
    echo

    wget https://dl.google.com/go/$VERSION

    echo
    echo "Wait for untar..."
    echo

    tar -xf go*.tar.gz --strip-components=1 -C /usr/local/go
    rm go*.tar.gz

    echo
    echo "Installed Go version"
    go version
    echo

    echo 
    echo "Additional tools:"
    echo "- go get -u github.com/go-delve/delve/cmd/dlv"
    echo "- go get -u github.com/shurcooL/goexec"
    echo

    # Please run this in nvim:
    # - GoInstallBinaries
fi
