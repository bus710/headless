#!/bin/bash

set -e

FILENAME="flutter.tar.xz"
RELEASES="" # Entire response from the releases API
SYSTEM=$(uname -s) # Linux or Darwin
ARCH=$(uname -m) # x86_64 (for most Linux and Intel mac) or arm64 (for Linux SBCs and m1 mac)
BASE_URL="https://storage.googleapis.com/flutter_infra_release/releases"
CHANNEL="beta"
OS=""               # will be assigned - linux or macos
CURRENT_ARCHIVE=""  # will be assigned
TARGET_ARCH=""      # will be assigned - x64 or arm64

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

find_version() {
    # Check the system type
    if [[ $SYSTEM == "Linux" ]]; then
        RELEASES=$(curl -s $BASE_URL/releases_linux.json)
        OS="linux"
    elif [[ $SYSTEM == "Darwin" ]]; then 
        RELEASES=$(curl -s $BASE_URL/releases_macos.json)
        OS="macos"
    else
        echo "Some issues are found - exit"
        exit -1
    fi

    # Decide the filter based on the architecture & system
    if [[ $SYSTEM == "Darwin" ]] && [[ $ARCH == "x86_64" ]]; then
        TARGET_ARCH="x64"
    elif [[ $SYSTEM == "Darwin" ]] && [[ $ARCH == "arm64" ]]; then
        TARGET_ARCH="arm64"
    elif [[ $SYSTEM == "Linux" ]]; then
        TARGET_ARCH="x64"
    fi

    # Filter out the keys
    CURRENT_HASH=$(echo $RELEASES | jq --raw-output --slurp .[]."current_release".beta)
    CURRENT_INFO=""

    CURRENT_INFO=$(echo $RELEASES \
        | jq --raw-output --slurp '.[].releases' \
        | jq --raw-output --arg hash_value $CURRENT_HASH --arg arch_value $TARGET_ARCH \
        '.[]|select((.hash==$hash_value) and (.dart_sdk_arch=$arch_value))')
    CURRENT_ARCHIVE=$(echo $CURRENT_INFO | jq -r '.|.archive')
}

confirmation(){
    term_color_red
    echo "Target version:"
    echo "- $CURRENT_ARCHIVE"
    term_color_white
    
    term_color_red
    echo "Do you want to install? (y/n)"
    term_color_white
    
    echo
    read -n 1 ans
    echo
    
    if [[ ! $ans == "y" ]]; then
        echo
        exit -1
    fi
}

install_packages(){
    if [[ $SYSTEM != "Linux" ]]; then
        term_color_red
        echo "Not Linux - packages will not be installed"
        term_color_white
        return
    fi

    term_color_red
    echo "Config for USB debugging"
    term_color_white
    
    sudo usermod -aG plugdev $LOGNAME
    sudo apt install -y \
        android-sdk-platform-tools-common \
        clang
}

install_flutter(){
    term_color_red
    echo "Download and install flutter SDK"
    term_color_white
   
    wget ${BASE_URL}/${CURRENT_ARCHIVE} -O $FILENAME
    
    term_color_red
    echo "Wait for untar..."
    term_color_white
    
    tar xf $FILENAME
    rm -rf ~/flutter
    mv flutter ~/
    rm $FILENAME
}

configure_runcom(){
    if [[ $SYSTEM != "Linux" ]]; then
        term_color_red
        echo "Not Linux - runcom will not be configured"
        term_color_white
        return
    fi

    term_color_red
    echo "Configure runcom"
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
    echo "Config the SDK"
    term_color_white
    
    flutter doctor
    flutter update-packages
    
    #echo "Change the channel"
    
    #flutter channel beta
    #flutter upgrade
    #flutter channel
    
    #echo "Install webdev"
    
    #flutter pub global activate webdev
    
    term_color_red
    echo "Enable/disable targets"
    term_color_white
    
    flutter config --no-enable-web
    flutter config --no-enable-linux-desktop
    #flutter config --no-enable-ios
    #flutter config --no-enable-android
    # flutter config --enable-macos-desktop
    flutter devices
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
find_version
confirmation
install_packages
install_flutter
configure_runcom
update_configuration
post
