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
        fonts-nanum \
        fonts-nanum-coding \
        fonts-noto-cjk 
}

install_kime (){
    term_color_red
    echo
    echo "Install Kime"
    echo
    term_color_white

    TARGET_KIME_VERSION=$(curl -o- -s https://api.github.com/repos/Riey/kime/releases/latest | jq -r '.tag_name')

    if [[ $OS_TYPE =~ "Debian" ]]; then
        wget -O kime.deb https://github.com/Riey/kime/releases/download/${TARGET_KIME_VERSION}/kime_debian-buster_${TARGET_KIME_VERSION}_amd64.deb
    elif [[ $OS_TYPE =~ "Ubuntu" ]]; then
        wget -O kime.deb https://github.com/Riey/kime/releases/download/${TARGET_KIME_VERSION}/kime_ubuntu-20.10_${TARGET_KIME_VERSION}_amd64.deb
    else
        echo "Not Debian or Ubuntu"
        exit
    fi

    cd $HOME/Downloads
    sudo dpkg -i kime.deb
    rm -rf kime.deb
}

configuration (){
    term_color_red
    echo "Set Kime configuration in \$HOME (for Ctrl+Space)"
    term_color_white

    rm -rf /home/$LOGNAME/.config/kime
    mkdir /home/$LOGNAME/.config/kime
    cp /usr/share/doc/kime/default_config.yaml /home/$LOGNAME/.config/kime/config.yaml
    sed -i '/Super-Space:/c\\ \ \ \ C-Space:' $HOME/.config/kime/config.yaml

    term_color_red
    echo "Configure IM module in /etc/environment"
    term_color_white

    KIME_GLOBAL_CONFIGURED=$(cat /etc/environment)
    if [[ ! $KIME_GLOBAL_CONFIGURED =~ "kime" ]]; then
        term_color_red
        echo "Set required Wayland global variables in /etc/environment"
        term_color_white

        sudo bash -c 'echo "export GTK_IM_MODULE=kime" >> /etc/environment'
        sudo bash -c 'echo "export QT_IM_MODULE=kime" >> /etc/environment'
        sudo bash -c 'echo "export XMODIFIERS=@im=kime" >> /etc/environment'
    fi
}

startup (){
    term_color_red
    echo
    echo "Add Kime as startup app"
    echo
    term_color_white

    sed -i '/#KIME_0/c\exec kime' $HOME/.config/sway/config
}

post (){
    term_color_red
    echo "Done!"
    echo "- install the korean support in settings - language/method"
    echo "- re-login and run kime-check"
    echo
    term_color_white

    rm -rf kime.deb
}


trap term_color_white EXIT
install_packages
install_kime
configuration
startup
post
