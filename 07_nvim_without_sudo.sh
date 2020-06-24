#!/bin/bash

if [ "$EUID" == 0 ]
then echo "Please run as a normal user (w/0 sudo)"
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

    sudo apt remove neovim
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

    sudo apt install -y fuse libfuse2 ack-grep 
    sudo apt install -y python3-pip
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.cache -R
    pip3 install --user -U testresources
    pip3 install --user -U wheel
    pip3 install --user -U setuptools --no-warn-script-location
    pip3 install --user -U neovim
    pip3 install --user -U pynvim
    pip3 install --user -U ranger-fm

    echo 
    echo "Copy the config files and run the post processor"
    echo 

    mkdir -p /home/$LOGNAME/.config/nvim
    mkdir -p /home/$LOGNAME/.config/nvim/autoload
    mkdir -p /home/$LOGNAME/.config/nvim/plugged

    curl -fLo /home/$LOGNAME/.config/nvim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cp init.vim /home/$LOGNAME/.config/nvim/init.vim
    cp ./coc-settings.json /home/$LOGNAME/.config/nvim/coc-settings.json

    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.config -R
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.local -R
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.tools -R

    nvim -v

    echo -e "\e[91m"
    echo "Run :PlugInstall"
    echo -e "\e[39m"
    echo

    # Do this in case of error - no python3 provider found
    # pip3 install pynvim
fi
