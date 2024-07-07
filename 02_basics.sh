#!/bin/bash

set -e

CPU_TYPE=$(uname -m)
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

confirmation(){
    term_color_red
    echo "Install some basic packages"
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        exit 1
    fi
}

install_basic_packages(){
    term_color_red
    echo "Install basic packages"
    term_color_white

    sudo apt update

    sudo apt install -y \
        zsh \
        vim \
        git \
        ncdu \
        htop \
        curl \
        tree \
        udev \
        iotop \
        unzip \
        psmisc \
        keychain \
        fastfetch \
        powerline \
        bash-completion \
        command-not-found \
        jq \
        fzf \
        ranger \
        ripgrep \
        xmlstarlet \
        aptitude
        # autofs \

    # https://manpages.debian.org/stretch/lm-sensors/sensors-detect.8.en.html
    # https://wiki.archlinux.org/title/lm_sensors
    # Please run `sudo sensors-detect --auto` to create the config file automatically
    sudo apt install -y \
        lm-sensors 
}

install_daemon_packages(){
    term_color_red
    echo "Install some daemon packages"
    term_color_white

    sudo apt install -y \
        openssh-server \
        avahi-daemon \
        avahi-utils
}

install_network_packages(){
    term_color_red
    echo "Install network packages"
    term_color_white

    sudo apt install -y \
        ufw \
        bmon \
        nmap \
        sshfs \
        fail2ban \
        net-tools \
        wireless-tools
}

install_nvim_base(){
    term_color_red
    echo "Install Python for nvim"
    term_color_white

    sudo apt install -y \
        python3-pip \
        python3-dev \
        python-is-python3
}

install_bluetooth_packages(){
    term_color_red
    echo "Install Bluetooth packages"
    term_color_white

    sudo apt install -y \
        bluez \
        bluetooth \
        bluez-tools

    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    sudo usermod -aG bluetooth $USER
}

install_platform_specific_packages(){
    term_color_red
    echo "Install platform specific packages"
    term_color_white

    if [[ $OS_TYPE =~ "Debian" ]]; then
        sudo apt install -y \
            software-properties-common
    fi

    if [[ $CPU_TYPE == "x86_64" ]]; then
        echo
    elif [[ $CPU_TYPE == "aarch64" ]]; then
        echo "Install for Raspbian OS"

        sudo apt install -y \
            file \
            pi-bluetooth
    fi
}

cleanup(){
    term_color_red
    echo "Cleanup"
    term_color_white

    sudo apt autoremove -y
}

update_capslock(){
    term_color_red
    echo "Update Capslock to nocaps"
    term_color_white

    sudo bash -c "echo 'XKBOPTIONS=ctrl:nocaps' >> /etc/default/keyboard"
    setupcon -k
}

update_ssh_port(){
    term_color_red
    echo "Update sshd port"
    term_color_white

    # Port update
    sudo bash -c "sed -i '/#Port 22/c\Port 2222' /etc/ssh/sshd_config"
    # No DNS for better performance
    sudo bash -c "sed -i '/#UseDNS no/c\UseDNS no' /etc/ssh/sshd_config"
}

update_timeout(){
    term_color_red
    echo "Update default timeout to stop from 90s to 7s"
    term_color_white

    sudo bash -c "sed -i '/#DefaultTimeoutStopSec=90s/c\DefaultTimeoutStopSec=7s' /etc/systemd/system.conf"
}

post(){
    term_color_red
    echo "1. SSH port number is changed"
    echo "2. Source your .bashrc (source ~/.bashrc)"
    echo "3. Capslock is disabled"
    echo "4. Try neofetch"
    echo
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_basic_packages
install_daemon_packages
install_network_packages
install_nvim_base
install_bluetooth_packages
install_platform_specific_packages
cleanup
update_capslock
update_ssh_port
update_timeout
post


