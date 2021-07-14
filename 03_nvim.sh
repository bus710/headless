#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "This will delete nvim and your nvim config first"
echo -e "\e[39m"
echo 
echo "Do you want to install? (y/n)"
echo

echo
read -n 1 ans
echo

if [[ $ans == "y" ]]
then 
    HOME="/home/$LOGNAME"

    echo 
    echo "Ask password for apt commands to install/remove things"
    echo 

    sudo apt install -y neovim
    sudo apt install -y fuse libfuse2 ack-grep 
    sudo apt install -y python3-pip
    sudo apt install -y python-is-python3

    echo 
    echo "Clean up existing configuration"
    echo 

    rm -rf /home/$LOGNAME/.config/nvim/*
    mkdir -p /home/$LOGNAME/.tools

    echo 
    echo "Create a symlink"
    echo

    sudo rm -rf /usr/bin/nv
    sudo ln -s /usr/bin/nvim /usr/bin/nv

    echo 
    echo "Install nvim dependencies"
    echo 

    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.cache -R
    pip3 install --user -U testresources
    pip3 install --user -U wheel
    pip3 install --user -U setuptools --no-warn-script-location
    pip3 install --user -U neovim
    pip3 install --user -U pynvim
    sudo npm install -g neovim

    echo 
    echo "Copy the config files and run the post process"
    echo 

    mkdir -p /home/$LOGNAME/.config/nvim
    mkdir -p /home/$LOGNAME/.config/nvim/autoload
    mkdir -p /home/$LOGNAME/.config/nvim/plugged

    curl -fLo /home/$LOGNAME/.config/nvim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cp init.vim /home/$LOGNAME/.config/nvim/init.vim
    cp ./coc-settings.json /home/$LOGNAME/.config/nvim/coc-settings.json

    chown -R $LOGNAME:$LOGNAME /home/$LOGNAME/.config
    chown -R $LOGNAME:$LOGNAME /home/$LOGNAME/.local 
    chown -R $LOGNAME:$LOGNAME /home/$LOGNAME/.tools 

    nvim -v

    echo
    echo "Install plugins"
    echo

    nvim -c :PlugInstall

    echo
    echo "Done"
    echo

    # Do this in case of error - no python3 provider found
    # pip3 install pynvim
fi
