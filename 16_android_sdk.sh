#!/bin/bash

set -e

URL_STUDIO="https://dl.google.com/android/studio/ide-zips/4.0.1.0/android-studio-ide-193.6626763-linux.tar.gz"
URL_SDK="https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip"

if [[ "$EUID" == 0 ]]
then echo "Please run as a normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "1. Please check the website if there is a newer version"
echo "  https://developer.android.com/studio#downloads"
echo "2. Existing SDK directory will be deleted"
echo "  rm $HOME/Android"
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
    echo "Prep directory"
    echo 

    cd ~
    rm -rf Android
    mkdir -p Android/cmdline-tools
    
    echo 
    echo "Config for USB debugging"
    echo

    sudo usermod -aG plugdev $LOGNAME
    sudo apt install -y \
        android-sdk-platform-tools-common

    echo 
    echo "Download IDE and SDK"
    echo 

    wget $URL_STUDIO
    wget $URL_SDK

    echo
    echo "Wait for untar..."
    echo

    tar xvf android-studio-ide-*-linux.tar.gz -C Android >> /dev/null 2>&1 
    rm -rf android-studio-ide-*-linux.tar.gz 

    unzip commandlinetools-linux-*_latest.zip >> /dev/null 2>&1
    mv tools Android/cmdline-tools/
    rm -rf commandlinetools-linux-*_latest.zip

    echo
    echo "Java config"
    echo

    sudo update-alternatives \
            --install \
            "/usr/bin/java" \
            "java" \
            "/home/$LOGNAME/Android/android-studio/jre/bin/java" \
            1

    sudo update-alternatives \
            --set \
            java \
            /home/$LOGNAME/Android/android-studio/jre/bin/java

    java -version

    echo
    echo "Add these variables to runcom"
    echo "  export JAVA_HOME=$HOME/Android/android-studio/jre"
    echo "  export PATH=$JAVA_HOME/bin:$PATH"
    echo "  export PATH=$HOME/Android/android-studio/bin:$PATH"
    echo "  export ANDROID_SDK_ROOT=$HOME/Android"
    echo "  export PATH=$HOME/Android/cmdline-tools/tools/bin:$PATH"
    echo "  export PATH=$HOME/Android/platform-tools:$PATH"
    echo

    echo
    echo "Install build tools"
    echo "  sdkmanager --version"
    echo "  sdkmanager --list"
    echo "  sdkmanager \"platform-tools\" \"platforms;android-29\""
    echo "  sdkmanager \"build-tools;29.0.3\""
    echo "  sdkmanager --licenses"
    echo
fi
