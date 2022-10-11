#!/bin/bash

set -e

CPU_TYPE=$(uname -m)
OS_TYPE=$(lsb_release -i)

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
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
    echo "Start installing some basic packages for Gtk"
    echo "Do you want to install? (y/n)"
    echo
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        echo "" 
        exit -1
    fi
}

install_packages (){
    # Don't install if not desktop (Gnome) environment
    ISGNOME=$(env | grep -E 'XDG.*gnome' | wc -w)
    if [[ ! "$ISGNOME" == "0" ]];    then
        term_color_red
        echo "Packages for Gtk"
        term_color_white

        sudo apt install -y \
            libgtk-3-dev \
            libgtk-4-dev \
            libcairo2-dev \
            libatk1.0-dev \
            gir1.2-gtk-3.0 \
            libglib2.0-dev \
            libpango1.0-dev \
            libadwaita-1-dev \
            libgraphene-1.0-dev \
            libgdk-pixbuf-2.0-dev \
            libgirepository1.0-dev

        #pip3 install autopep8
        #pip3 install psutil
        #pip3 install pexpect
        #pip3 install websockets
        #pip3 install Pycairo
        #pip3 install PyGobject PyGObject-stubs

        term_color_red
        echo "Install Gnome-Builder"
        term_color_white

        sudo apt install -y \
            gnome-builder

    fi
}

cleanup(){
    term_color_red
    echo
    echo "Cleanup"
    echo 
    term_color_white

    sudo apt autoremove -y
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
install_packages
cleanup
post
