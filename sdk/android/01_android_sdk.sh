#!/bin/bash

set -e

URL_STUDIO="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/"
URL_STUDIO+="2022.3.1.21/android-studio-2022.3.1.21-linux.tar.gz"

URL_SDK="https://dl.google.com/android/repository/"
URL_SDK+="commandlinetools-linux-10406996_latest.zip"

if [[ "$EUID" == 0 ]]
then echo "Please run as a normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation() {
    term_color_red
    echo "1. Please check the website if there is a newer version"
    echo "  https://developer.android.com/studio#downloads"
    echo "2. Existing SDK directory will be deleted"
    echo "  rm $HOME/Android"
    echo 
    echo "Do you want to install? (y/n)"
    echo
    term_color_white

    read -n 1 ans

    if [[ ! $ans == "y" ]]; then 
        exit 1
    fi
}

install_ide_and_sdk(){
    term_color_red
    echo "Download IDE and SDK"
    term_color_white

    cd $HOME

    FILE_STUDIO=$(ls $HOME/android-studio-*.tar.gz 2> /dev/null | wc -l)
    if [[ $FILE_STUDIO == "0" ]]; then
        echo "STUDIO file is not exist"
        wget $URL_STUDIO
    else
        echo "STUDIO file is exist"
    fi

    FILE_SDK=$(ls $HOME/commandlinetools-linux-*_latest.zip 2> /dev/null | wc -l)
    if [[ $FILE_SDK == "0" ]]; then
        echo "SDK file is not exist"
        wget $URL_SDK
    else
        echo "SDK file is exist"
    fi
}

prep_files(){
    term_color_red
    echo "Prep directory"
    term_color_white

    rm -rf Android
    mkdir -p Android/cmdline-tools

    term_color_red
    echo "Wait for untar..."
    term_color_white

    ls android-studio-*.tar.gz | xargs tar xf >> /dev/null 2>&1
    mv android-studio Android

    unzip commandlinetools-linux-*_latest.zip >> /dev/null 2>&1
    mv cmdline-tools latest
    mv latest Android/cmdline-tools/
}

configure_java(){
    term_color_red
    echo "Java config"
    term_color_white

    sudo update-alternatives \
        --install \
        "/usr/bin/java" \
        "java" \
        "/home/$LOGNAME/Android/android-studio/jre/bin/java" \
        1

    echo
    sudo update-alternatives \
        --set \
        java \
        /home/$LOGNAME/Android/android-studio/jre/bin/java

    term_color_red
    echo "Java version"
    term_color_white

    java -version
}

configure_usb_debugging(){
    term_color_red
    echo "Config for USB debugging"
    term_color_white

    sudo usermod -aG plugdev $LOGNAME
    sudo apt install -y \
        android-sdk-platform-tools-common
}

cleanup(){
    term_color_red
    echo "Cleanup"
    term_color_white

    rm android-studio-*.tar.gz
    rm commandlinetools-linux-*_latest.zip
}

configure_runcom(){
    term_color_red
    echo "Activate variables in ~/.shrc"
    term_color_white

    sed -i '/#ANDROID_0/c\export JAVA_HOME=\$HOME\/Android\/android-studio\/jre' /home/$LOGNAME/.shrc
    sed -i '/#ANDROID_1/c\export PATH=\$JAVA_HOME\/bin:\$PATH' /home/$LOGNAME/.shrc
    sed -i '/#ANDROID_2/c\export PATH=\$HOME\/Android\/android-studio\/bin:\$PATH' /home/$LOGNAME/.shrc
    sed -i '/#ANDROID_3/c\export ANDROID_SDK_ROOT=\$HOME\/Android' /home/$LOGNAME/.shrc
    sed -i '/#ANDROID_4/c\export PATH=\$HOME\/Android\/cmdline-tools\/latest\/bin:\$PATH' /home/$LOGNAME/.shrc
    sed -i '/#ANDROID_5/c\export PATH=\$HOME\/Android\/platform-tools:\$PATH' /home/$LOGNAME/.shrc
}

post(){
    term_color_red
    echo "Please source ~/.shrc"
    echo
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_ide_and_sdk
prep_files
configure_java
configure_usb_debugging
cleanup
configure_runcom
post
