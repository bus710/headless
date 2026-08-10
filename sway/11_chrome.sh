#!/bin/bash

set -e

URL="https://dl.google.com/linux/direct/"
PACKAGE_NAME="google-chrome-stable_current_amd64.deb"


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

function install(){
    echo 
    echo "Install Chrome Browser"
    echo 

    cd ~/Downloads
    wget ${URL}${PACKAGE_NAME}
    # Use `apt install ./file.deb` (not `dpkg -i`) so apt resolves and installs
    # Chrome's dependencies in the same transaction. `dpkg -i` only unpacks and
    # leaves unmet deps half-configured, which is what forces the manual
    # `apt --fix-broken install` afterward. The leading ./ makes apt treat it as
    # a local file rather than a package name to fetch from the repos.
    sudo apt install -y ./${PACKAGE_NAME}
}

# Remove the downloaded .deb on exit (success or failure). rm -f so it is a
# harmless no-op if the download never happened.
function cleanup(){
    rm -f ~/Downloads/${PACKAGE_NAME}
}

function post(){
    term_color_red
    echo
    echo "Done"
    echo "- Enable chrome://flags/#enable-webrtc-pipewire-capturer for Google Meet screen sharing in SwayWM"
    echo "- Enable chrome://flags/#ozone-platform-hint as wayland for Google Meet screen sharing in SwayWM"
    echo
    term_color_white
}

trap cleanup EXIT
install
post
