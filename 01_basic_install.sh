#!/bin/bash

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "Start installing some basic packages"
echo "  for the NeoVim/Go/Flutter/Docker development"
echo -e "\e[39m"
echo

echo "Do you want to install? (y/n)"

read -n 1 ans
echo

if [ $ans == "y" ]
then 
    # Get logname first (this is not $USER)
    LOGNAME="$(logname)"

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

    # To apply Go/Flutter SDK path to the PATH variable
    cat shrc >> /home/$LOGNAME/.shrc
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.shrc

    echo "" >> /home/$LOGNAME/.bashrc
    echo "source /home/$LOGNAME/.shrc" >> /home/$LOGNAME/.bashrc
    source /home/$LOGNAME/.bashrc

    # To apply ^a shortcut to the tmux config
    cat tmux.conf >> /home/$LOGNAME/.tmux.conf
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.tmux.conf

    # Cleanup
    apt autoremove

    echo
    echo "1. CHANGE THE PORT NUMBER OF SSH"
    echo "2. SOURCE YOUR .bashrc (source ~/.bashrc)"
    echo "3. CHECK YOUR .tmux.conf"
    echo
fi
