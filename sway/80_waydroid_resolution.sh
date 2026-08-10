#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as super user (w/o sudo)"
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
    echo "Pick a resolution and DPI"
    echo
    echo "Do you want to proceed?"
    echo "- Press '1' for 1280 x 720"
    echo "- Press '2' for 1920 x 1080"
    echo "- Press '3' for 3840 x 2160"
    echo "- Press '4' to exit"
    term_color_white

    read -n 1 ans
    echo

    sudo echo

    if [[ $ans == "1" ]]; then
        term_color_red
        echo "1280x720 and DPI 180"
        term_color_white
        waydroid prop set persist.waydroid.width 1200
        waydroid prop set persist.waydroid.height 700
        waydroid prop set persist.waydroid.dpi 180
    elif [[ $ans == "2" ]]; then
        term_color_red
        echo "1920x1080 and DPI 240"
        term_color_white
        waydroid prop set persist.waydroid.width 1800
        waydroid prop set persist.waydroid.height 960
        waydroid prop set persist.waydroid.dpi 240
    elif [[ $ans == "3" ]]; then
        term_color_red
        echo "3840x2160 and DPI 480"
        term_color_white
        waydroid prop set persist.waydroid.width 3760
        waydroid prop set persist.waydroid.height 2060
        waydroid prop set persist.waydroid.dpi 480
    else
        term_color_red
        echo "Exit"
        term_color_white

        exit 1
    fi

    waydroid session stop
    sudo systemctl restart waydroid-container

    term_color_red
    echo "Done - restart the app"
    term_color_white
    echo
}

trap term_color_white EXIT
confirmation

