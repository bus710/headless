#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo -e "\e[91m"
echo "Start installing some basic packages"
echo
echo "Do you want to install? (y/n)"
echo -e "\e[39m"

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]
then 
    echo
    echo "Install basics"
    echo

    sudo apt update

    sudo apt install -y \
    	zsh \
        vim \
        git \
        htop \
        tmux \
        curl \
        tree \
        udev \
        iotop \
        unzip \
        autofs \
        sqlite3 \
        minicom \
        keychain \
        neofetch \
        powerline \
        lm-sensors \
        exuberant-ctags \
        bash-completion \
        command-not-found
#http \ #ubuntu 21.04 doesn't have it

    sudo apt install -y \
        make \
        cmake \
        ninja-build \
        build-essential

    sudo apt install -y \
        jq \
        fzf \
        ncdu \
        ranger \
        ripgrep

    echo
    echo "Install network packages"
    echo

    sudo apt install -y \
        ufw \
        bmon \
        nmap \
        sshfs \
        fail2ban \
        net-tools \
        wireless-tools \

    echo
    echo "Install for nvim"
    echo

    sudo apt install -y \
        python3-dev

    echo
    echo "Install some daemons"
    echo

    # For daemons required
    sudo apt install -y \
        openssh-server \
        avahi-daemon \
        avahi-utils

    echo
    echo "Install for nodejs for nvim/coc"
    echo

    sudo apt install -y nodejs npm yarnpkg

    echo
    echo "Install for docker"
    echo

    # For Docker
    sudo apt install -y \
        gnupg-agent \
        apt-transport-https \
        ca-certificates \
        software-properties-common

    echo
    echo "Bluetooth"
    echo

    sudo apt install -y \
        bluez \
        bluetooth \
        bluez-tools

    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
    sudo usermod -aG bluetooth $USER
 
    # Depends on the architecture 
    CPU_TYPE=$(uname -m)

    if [[ $CPU_TYPE == "x86_64" ]]; then
        echo
        echo "Install for Flutter SDK"
        echo

        sudo apt install -y lib32stdc++6

    elif [[ $CPU_TYPE == "aarch64" ]]; then
        echo
        echo "Install pi-bluetooth"
        echo

        sudo apt install -y pi-bluetooth
    fi

    echo
    echo "Config bash/zsh"
    echo

    # To apply Go/Flutter SDK path to the PATH variable
    rm -rf /home/$LOGNAME/.shrc
    cat shrc >> /home/$LOGNAME/.shrc
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.shrc

    echo "" >> /home/$LOGNAME/.bashrc
    echo "source /home/$LOGNAME/.shrc" >> /home/$LOGNAME/.bashrc
    source /home/$LOGNAME/.bashrc

    echo
    echo "Config tmux"
    echo

    # To apply ^a shortcut to the tmux config
    cat tmux.conf >> /home/$LOGNAME/.tmux.conf
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.tmux.conf

    echo
    echo "Disable Capslock"
    echo

    sudo bash -c "echo 'XKBOPTIONS=ctrl:nocaps' >> /etc/default/keyboard"
    setupcon -k

    echo
    echo "Cleanup"
    echo 

    sudo apt autoremove -y

    echo
    echo "Change sshd port"
    echo
    # sudo sed -i 's/Port 22/Port 2222/g' /etc/ssh/sshd_config
    sudo bash -c "sed -i '/#Port 22/c\Port 2222' /etc/ssh/sshd_config"
    # Also, "UseDNS no" can be uncommented if sshd is too slow

    echo -e "\e[91m"
    echo "1. SSH port number is changed"
    echo "2. Source your .bashrc (source ~/.bashrc)"
    echo "3. Check your .tmux.conf"
    echo "4. Capslock is disabled"
    echo "5. Try neofetch"
    echo -e "\e[39m"
    echo
    echo "Done"
    echo
fi
