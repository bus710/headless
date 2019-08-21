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
    apt install -y build-essential 
    apt install -y cmake 
    apt install -y exuberant-ctags
    apt install -y git
    apt install -y bash-completion 
    apt install -y command-not-found 
    apt install -y bmon 
    apt install -y htop
    apt install -y tmux
    apt install -y minicom
    apt install -y powerline
    apt install -y curl
    apt install -y tree

    # For Flutter SDK 
    apt install -y lib32stdc++6

    # For daemons required
    apt install -y openssh-server
    apt install -y avahi-daemon
    apt install -y avahi-utils

    # For Docker
    apt install -y apt-transport-https
    apt install -y ca-certificates
    apt install -y gnupg-agent 
    apt install -y software-properties-common

    # To apply Go/Flutter SDK path to the PATH variable
    cat bashrc >> /home/$LOGNAME/.bashrc

    # Cleanup
    apt autoremove

    echo
    echo "!! CHANGE THE PORT NUMBER OF SSH !!"
    echo "!! SOURCE YOUR .bashrc (source ~/.bashrc) !!"
    echo
fi
