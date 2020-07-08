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
    # Get logname first (this is not $USER)
    LOGNAME=$(logname)

    HOME="/home/$LOGNAME"

    echo 
    echo "Ask password for apt commands to install/remove things"
    echo 

    sudo apt remove -y neovim
    sudo apt install -y fuse libfuse2 ack-grep 
    sudo apt install -y python3-pip

    echo 
    echo "Clean up existing"
    echo 

    rm -rf /home/$LOGNAME/.tools/nvim /home/$LOGNAME/.tools/nvim.appimage
    rm -rf /home/$LOGNAME/.config/nvim/*

    echo 
    echo "Install neovim"
    echo

    CPU_TYPE=$(uname -p)

    if [[ "$CPU_TYPE" == "x86_64" ]]; then
        curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
        chown $LOGNAME:$LOGNAME nvim.appimage
        chmod u+x nvim.appimage
        mkdir -p /home/$LOGNAME/.tools
        mv nvim.appimage /home/$LOGNAME/.tools/nvim.appimage
        ln -s /home/$LOGNAME/.tools/nvim.appimage /home/$LOGNAME/.tools/nvim 
        sudo cp /home/$LOGNAME/.tools/nvim.appimage /usr/bin/nvim.appimage
        sudo rm -rf /usr/bin/nvim
        sudo rm -rf /usr/bin/nv
        sudo ln -s /usr/bin/nvim.appimage /usr/bin/nvim
        sudo ln -s /usr/bin/nvim.appimage /usr/bin/nv
    elif [[ "$CPU_TYPE" == "aarch64" ]]; then
        sudo apt install -y neovim
    else
        exit
    fi

    echo 
    echo "Install nvim dependencies"
    echo 

    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.cache -R
    pip3 install --user -U testresources
    pip3 install --user -U wheel
    pip3 install --user -U setuptools --no-warn-script-location
    pip3 install --user -U neovim
    pip3 install --user -U pynvim

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
