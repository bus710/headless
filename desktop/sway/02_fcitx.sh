#!/bin/bash

set -e

OS_TYPE=$(lsb_release -i)

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi


term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}


install_packages (){
    term_color_red
    echo
    echo "Install language packs and fonts"
    echo 
    term_color_white

    #sudo apt install -y \
    #    language-pack-gnome-ko \
    #    language-pack-gnome-en

    sudo apt install -y \
    fcitx5 \
    fcitx5-config-qt \
    fcitx5-hangul

    sudo apt install -y \
        fonts-nanum \
        fonts-nanum-coding \
        fonts-noto-cjk 
}

configuration (){
    term_color_red
    echo "Configure IM module in /etc/environment"
    term_color_white

    GLOBAL_CONFIGURED=$(cat /etc/environment)
    if [[ ! $GLOBAL_CONFIGURED =~ "fcitx" ]]; then
        term_color_red
        echo "Set required Wayland global variables in /etc/environment"
        term_color_white

        #sudo bash -c 'echo "export GTK_IM_MODULE=fcitx" >> /etc/environment'
        sudo bash -c 'echo "export QT_IM_MODULE=fcitx" >> /etc/environment'
        sudo bash -c 'echo "export XMODIFIERS=@im=fcitx" >> /etc/environment'
        sudo bash -c 'echo "export GLFW_IM_MODULE=ibus" >> /etc/environment'
        sudo bash -c 'echo "export SDL_IM_MODULE=fcitx" >> /etc/environment'
    fi
}

post (){
    term_color_red
    echo "Done!"
    echo "- install the korean support in the Fcitx config"
    echo "- reboot and run fcitx5-config-qt"
    echo "- update a Chrome flag - preffered ozone platform"
    echo
    term_color_white
}


trap term_color_white EXIT
install_packages
configuration
post
