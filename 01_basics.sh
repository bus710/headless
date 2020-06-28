#!/bin/bash

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

echo -e "\e[91m"
echo "Start installing some basic packages"
echo "  for the NeoVim/Go/Flutter/Docker development"
echo
echo "Do you want to install? (y/n)"
echo -e "\e[39m"

read -n 1 ans
echo

if [ $ans == "y" ]
then 
    # Get logname first (this is not $USER)
    LOGNAME="$(logname)"

    echo
    echo "Install basics"
    echo

    apt update

    # For general packages
    apt install -y \
    	zsh \
        vim \
        git \
        fzf \
        bmon \
        htop \
        tmux \
        curl \
        tree \
        nmap \
        cmake \
        sshfs \
        ripgrep \
        sqlite3 \
        minicom \
        fail2ban \
        neofetch \
        powerline \
        build-essential \
        exuberant-ctags \
        bash-completion \
        command-not-found

    # For general packages (cont.)
    apt install -y \
        net-tools \
        wireless-tools \
        ufw \
        gufw \
        inxi \
        glmark2

    # For Flutter SDK 
    apt install -y lib32stdc++6

    # For neovim and coc
    apt install -y python3-dev

    # For daemons required
    apt install -y \
        openssh-server \
        avahi-daemon \
        avahi-utils

    # For Docker
    apt install -y \
        gnupg-agent \
        apt-transport-https \
        ca-certificates \
        software-properties-common

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
