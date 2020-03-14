#!/bin/bash

if [ "$EUID" != 0 ]
then echo "Please run as the super user (w/ sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "This will delete nvim and your nvim config first"
echo -e "\e[39m"
echo 
echo "Do you want to install? (y/n)"
echo

read -n 1 ans
echo

if [ $ans == "y" ]
then 
    # Get logname first (this is not $USER)
    LOGNAME="$(logname)"

    HOME="/home/$LOGNAME"

    echo 
    echo "Clean up first"
    echo 

    apt remove neovim
    rm /home/$LOGNAME/.tools/nvim /home/$LOGNAME/.tools/nvim.appimage
    rm -rf /home/$LOGNAME/.config/nvim/*

    echo 
    echo "Install neovim and packages"
    echo

    curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    chown $LOGNAME:$LOGNAME nvim.appimage
    chmod u+x nvim.appimage
    mkdir -p /home/$LOGNAME/.tools
    mv nvim.appimage /home/$LOGNAME/.tools/nvim.appimage
    ln -s /home/$LOGNAME/.tools/nvim.appimage /home/$LOGNAME/.tools/nvim 
    cp /home/$LOGNAME/.tools/nvim.appimage /usr/bin/nvim.appimage
    ln -s /usr/bin/nvim.appimage /usr/bin/nvim

    apt install -y fuse libfuse2 ack-grep 
    apt install -y python3-pip
    pip3 install wheel
    pip3 install --user neovim
    pip3 install pynvim
    #apt install -y python-pip
    #pip install --user neovim

    echo 
    echo "Copy the config files and run the post processor"
    echo 

    mkdir -p /home/$LOGNAME/.config/nvim
    mkdir -p /home/$LOGNAME/.config/nvim/autoload
    mkdir -p /home/$LOGNAME/.config/nvim/plugged

    curl -fLo /home/$LOGNAME/.config/nvim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cp init.vim /home/$LOGNAME/.config/nvim/init.vim

    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.config -R
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.local -R

    nvim -v

    echo
    echo "Run :PlugInstall"
    echo

    # TODO: airline installation
fi
