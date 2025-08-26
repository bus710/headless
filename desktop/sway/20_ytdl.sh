#!/bin/bash

set -e

CPU_TARGET=""
RELEASE_URL=https://api.github.com/repos/ytdl-org/ytdl-nightly/releases/latest
RELEASE=""

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

check_version(){
    sudo echo
    RELEASE=$(curl -o- -s $RELEASE_URL| jq -r '.tag_name')
}

confirmation(){
    term_color_red
    echo "What will happen:"
    echo "- Remove and reinstall /usr/local/bin/ytdl"
    echo
    echo "Do you want to proceed? (y/n)"
    term_color_white

    read -n 1 ans
    echo

    if [[ $ans == "y" ]]; then
        :
    else
        exit 1
    fi

    echo
    echo "The target version is $RELEASE"
}

cleanup(){
    term_color_red
    echo "Clean-up"
    term_color_white

    # Remove if there is old tarballs
    sudo rm -rf /usr/local/bin/ytdl
}

install(){
    term_color_red 
    echo "Install"
    term_color_white

    sudo curl -L https://github.com/ytdl-org/ytdl-nightly/releases/download/$RELEASE/youtube-dl -o /usr/local/bin/ytdl
    sudo chmod a+rx /usr/local/bin/ytdl
    cd -
}

post(){
    term_color_red
    echo "Done"
    echo "- ytdl -F: to see the available formats"
    echo "- ytdl -f 140 $URL: for 128kbps mp4 audio"
    echo "- ytdl -f 137 $URL: for 1080p mp4 video"
    echo "- ytdl -f 136 $URL: for 720mp4 video"
    term_color_white
}

trap term_color_white EXIT
check_version
confirmation
cleanup
install
post
