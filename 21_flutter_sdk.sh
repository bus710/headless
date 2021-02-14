#!/bin/bash

set -e

URL="https://storage.googleapis.com/flutter_infra/releases/beta/linux/"
VERSION="flutter_linux_1.25.0-8.3.pre-beta.tar.xz"

if [[ "$EUID" == 0 ]]
then echo "Please run as a normal user (w/o sudo)"
  exit
fi


CPU_TYPE=$(uname -m)

if [[ $CPU_TYPE != "x86_64" ]]; then
    echo
    echo "Only x86_64 can be used"
    echo
    exit
fi



echo
echo -e "\e[91m"
echo "1. Please check the website if there is a newer version"
echo "  https://flutter.dev/docs/development/tools/sdk/releases?tab=linux"
echo "2. This will be installed but changed"
echo "  $VERSION"
echo "3. Existing SDK directory will be deleted"
echo "  rm $HOME/flutter"
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
    echo "Config for USB debugging"
    echo

    sudo usermod -aG plugdev $LOGNAME
    sudo apt install -y \
        android-sdk-platform-tools-common

    echo 
    echo "Download and install flutter SDK"
    echo 

    wget $URL$VERSION

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
    flutter update-packages

    #echo
    #echo "Change the channel"
    #echo

    #flutter channel beta
    #flutter upgrade
    #flutter channel

    echo 
    echo "Install webdev" 
    echo

    flutter pub global activate webdev

    echo
    echo "Enable chrome as a target device"
    echo

    # --no-enable-web, --enable-linux-desktop
    flutter config --enable-web 
    flutter devices

    echo
    echo "Done"
    echo
fi
