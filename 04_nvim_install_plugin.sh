#!/bin/bash

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

echo
echo "This will delete nvim and your nvim config first"
echo "Do you want to install? (y/n)"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then 
    # Get logname first (this is not $USER)
    LOGNAME="$(logname)"

    echo 
    echo "Clean up first"
    echo 

    apt remove neovim
    rm /usr/bin/nvim /usr/bin/nvim.appimage
    rm -rf /home/$LOGNAME/.config/nvim/*

    echo 
    echo "Install neovim and packages"
    echo

    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage /usr/bin/nvim.appimage
    ln -s /usr/bin/nvim.appimage /usr/bin/nvim 

    apt install -y fuse libfuse2 ack-grep 
    apt install -y python3-pip
    apt install -y python-pip

    pip install --user neovim
    pip3 install --user neovim

    echo 
    echo "Copy the config files and run the post processor"
    echo 

    mkdir /home/$LOGNAME/.config/nvim
    mkdir /home/$LOGNAME/.config/nvim/autoload
    mkdir /home/$LOGNAME/.config/nvim/plugged

    curl -fLo /home/$LOGNAME/.config/nvim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cp init.vim /home/$LOGNAME/.config/nvim/init.vim

    nvim -v

    echo
    echo "Run :PlugInstall"
    echo

    # TODO: airline installation
fi
