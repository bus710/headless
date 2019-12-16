#!/bin/bash

VERSION="flutter_linux_v1.9.1+hotfix.2-stable.tar.xz"

if [ "$EUID" == 0 ]
then echo "Please run as a normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "Please check the website if there is a newer version"
echo "https://flutter.dev/docs/get-started/install/linux"
echo 
echo "$VERSION will be installed"
echo "~/flutter will be deleted"
echo -e "\e[39m"
echo 
echo "Do you want to install? (y/n)"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then
    echo 
    echo "Download and install flutter SDK"
    echo 

    wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/$VERSION

    echo
    echo "Wait for untar..."
    echo

    tar xf $VERSION
    rm -rf ~/flutter
    mv flutter ~/
    rm $VERSION

    echo 
    echo "Config the SDK"
    echo 

    flutter doctor

    echo
    echo "Change the channel"
    echo

    flutter channel beta
    flutter channel
    flutter upgrade

    echo 
    echo "Install webdev" 
    echo

    flutter pub global activate webdev

    echo
    echo "Enable chrome as a target device"
    echo

    flutter config --enable-web
    flutter devices

fi
