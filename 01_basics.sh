#!/bin/bash

if [ "$EUID" != 0 ]
then echo "Please run as super user (w/ sudo)"
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

if [ $ans == "y" ]
then 
    # Get logname first (this is not $USER)
    LOGNAME=$(logname)

    echo
    echo "Install basics"
    echo

    apt update

    apt install -y \
    	zsh \
        vim \
        git \
        fzf \
        htop \
        tmux \
        curl \
        tree \
        make \
        cmake \
        ripgrep \
        sqlite3 \
        minicom \
        neofetch \
        powerline \
        build-essential \
        exuberant-ctags \
        bash-completion \
        command-not-found

    echo
    echo "Install network packages"
    echo

    apt install -y \
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

    apt install -y python3-dev

    echo
    echo "Install some daemons"
    echo

    # For daemons required
    apt install -y \
        openssh-server \
        avahi-daemon \
        avahi-utils

    echo
    echo "Install for docker"
    echo

    # For Docker
    apt install -y \
        gnupg-agent \
        apt-transport-https \
        ca-certificates \
        software-properties-common

    # RPi related
    CPU_TYPE=$(uname -p)

    if [[ $CPU_TYPE == "x86_64" ]]; then
        echo
        echo "Install for Flutter SDK"
        echo

        apt install -y lib32stdc++6
    elif [[ $CPU_TYPE == "aarch64" ]]; then
        echo
        echo "Install basics for RPi"
        echo

        apt install -y \
            bluez \
            bluetooth \
            bluez-tools \
            pi-bluetooth
        systemctl enable bluetooth.service
        systemctl start bluetooth.service
        usermod -aG bluetooth ubuntu
                    
        echo
        echo "Disable networkd wait"
        echo
        # to check boot delay                  
        # systemd-analyze blame                
        # to eliminate boot delay              
        systemctl disable systemd-networkd-wait-online.service
        systemctl mask systemd-networkd-wait-online.service
    fi

    echo
    echo "Config bash/zsh"
    echo

    # To apply Go/Flutter SDK path to the PATH variable
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
    echo "Cleanup"
    echo 

    apt autoremove

    echo
    echo "Change sshd port"
    echo
    # sed -i 's/Port 22/Port 2222/g' /etc/ssh/sshd_config
    sed -i '/#Port 22/c\Port 2222' /etc/ssh/sshd_config

    echo -e "\e[91m"
    echo "1. SSH port number is changed"
    echo "2. Source your .bashrc (source ~/.bashrc)"
    echo "3. Check your .tmux.conf"
    echo -e "\e[39m"
fi
