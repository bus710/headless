#!/bin/bash

set -e

# TODO: parse the response of this URL for VERSION
# https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json

URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/"
VERSION="flutter_linux_3.0.5-stable.tar.xz"

if [[ "$EUID" == 0 ]]; then
    echo "Please run as a normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo
    echo "1. Please check the website if there is a newer version"
    echo "  https://flutter.dev/docs/development/tools/sdk/releases?tab=linux"
    echo "2. This will be installed but changed"
    echo "  $VERSION"
    echo "3. Existing SDK directory will be deleted"
    echo "  rm $HOME/flutter"
    echo
    echo "Do you want to install? (y/n)"
    echo
    term_color_white
    
    echo
    read -n 1 ans
    echo
    
    if [[ ! $ans == "y" ]]; then
        echo
        exit -1
    fi
}

check_architecture(){
    CPU_TYPE=$(uname -m)
    if [[ $CPU_TYPE != "x86_64" ]] && [[ $CPUTYPE != "aarch64" ]]; then
        term_color_red
        echo
        echo "x86_64 or aarch64 can be used"
        echo
        term_color_white
        exit -1
    fi
}

install_packages(){
    term_color_red
    echo
    echo "Config for USB debugging"
    echo
    term_color_white
    
    sudo usermod -aG plugdev $LOGNAME
    sudo apt install -y \
    android-sdk-platform-tools-common \
    clang
}

install_flutter(){
    term_color_red
    echo
    echo "Download and install flutter SDK"
    echo
    term_color_white
    
    wget $URL$VERSION
    
    term_color_red
    echo
    echo "Wait for untar..."
    echo
    term_color_white
    
    tar xf $VERSION
    rm -rf ~/flutter
    mv flutter ~/
    rm $VERSION
}

configure_runcom(){
    term_color_red
    echo
    echo "Configure runcom"
    echo
    term_color_white
    
    if [[ -f /home/$LOGNAME/flutter/bin/flutter ]]; then
        sed -i '/#FLUTTER_0/c\export PATH=\$PATH:\$HOME\/flutter\/bin' /home/$LOGNAME/.shrc
        sed -i '/#FLUTTER_1/c\export PATH=\$PATH:\$HOME\/flutter\/bin\/cache\/dart-sdk\/bin' /home/$LOGNAME/.shrc
        sed -i '/#FLUTTER_2/c\export PATH=\$PATH:\$HOME\/flutter\/.pub-cache\/bin' /home/$LOGNAME/.shrc
        sed -i '/#FLUTTER_3/c\export PATH=\$PATH:\$HOME\/repo\/flutter\/bin' /home/$LOGNAME/.shrc # embedded 
        
        source /home/$LOGNAME/.shrc
    fi
}

update_configuration(){
    term_color_red
    echo
    echo "Config the SDK"
    echo
    term_color_white
    
    flutter doctor
    flutter update-packages
    
    #echo
    #echo "Change the channel"
    #echo
    
    #flutter channel beta
    #flutter upgrade
    #flutter channel
    
    #echo
    #echo "Install webdev"
    #echo
    
    #flutter pub global activate webdev
    
    term_color_red
    echo
    echo "Enable/disable targets"
    echo
    term_color_white
    
    flutter config --no-enable-web
    flutter config --enable-linux-desktop
    #flutter config --no-enable-ios
    #flutter config --no-enable-android
    # flutter config --enable-macos-desktop
    flutter devices
}

post(){
    term_color_red
    echo
    echo "Done"
    echo
    term_color_white
}

trap term_color_white EXIT
confirmation
check_architecture
install_packages
install_flutter
configure_runcom
update_configuration
post
