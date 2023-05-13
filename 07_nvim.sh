#!/bin/bash

set -e

OS_TYPE=$(lsb_release -i)
ARCH_TYPE=$(uname -m)

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo "This will delete nvim and your nvim config first"
    echo "Do you want to install? (y/n)"
    echo
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        exit -1
    fi
}

install_neovim(){
    HOME="/home/$LOGNAME"

    term_color_red
    echo "Install neovim"
    term_color_white

    sudo apt remove -y \
        neovim \
        neovim-runtime

    if [[ $OS_TYPE =~ "Ubuntu" ]]; then
        term_color_red
        echo "Add the neovim PPA for unstable"
        term_color_white

        sudo add-apt-repository ppa:neovim-ppa/unstable
        sudo apt update
        sudo apt install -y neovim

    elif [[ $OS_TYPE =~ "Debian" && $ARCH_TYPE =~ "x86_64" ]]; then
        term_color_red
        echo "Download the nightly pre-built from Github"
        term_color_white

        cd /home/$LOGNAME/Downloads

        #wget -q https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.deb
        #sudo dpkg -i nvim-linux64.deb
        #rm -rf nvim-linux64.deb

        wget -q \
            https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
            --output-document nvim
        chmod +x nvim
        sudo chown root:root nvim
        sudo mv nvim /usr/bin

        cd -
    else
        term_color_red
        echo "Just install from the OS repo"
        term_color_white

        sudo apt install -y neovim
    fi

    term_color_red
    echo "Install required packages"
    term_color_white

    sudo apt install -y fuse libfuse2 ack-grep

    term_color_red
    echo "Clean up existing configuration"
    term_color_white

    rm -rf /home/$LOGNAME/.config/nvim/*
    mkdir -p /home/$LOGNAME/.tools

    term_color_red
    echo "Create a symlink"
    term_color_white

    sudo rm -rf /usr/bin/nv
    sudo ln -s /usr/bin/nvim /usr/bin/nv
}

install_dependencies(){
    term_color_red
    echo "Install nvim dependencies"
    term_color_white

    chown $LOGNAME:$LOGNAME /home/$LOGNAME/.cache -R

    # Got warning that says - externally managed environment
    # system wide python packages should be installed via apt
    #pip3 install --user -U testresources
    #pip3 install --user -U wheel
    #pip3 install --user -U setuptools --no-warn-script-location
    #pip3 install --user -U neovim
    #pip3 install --user -U pynvim

    sudo apt install -y \
        python3-testresources \
        python3-wheel \
        python3-setuptools \
        python3-neovim \
        python3-pynvim
    npm install -g neovim
}

update_configuration(){
    term_color_red
    echo "Copy the config files and run the post process"
    term_color_white

    mkdir -p /home/$LOGNAME/.config/nvim
    mkdir -p /home/$LOGNAME/.config/nvim/autoload
    mkdir -p /home/$LOGNAME/.config/nvim/plugged

    curl -fLo /home/$LOGNAME/.config/nvim/autoload/plug.vim \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cp init.vim /home/$LOGNAME/.config/nvim/init.vim
    cp ./coc-settings.json /home/$LOGNAME/.config/nvim/coc-settings.json

    chown -R $LOGNAME:$LOGNAME /home/$LOGNAME/.config
    chown -R $LOGNAME:$LOGNAME /home/$LOGNAME/.local
    chown -R $LOGNAME:$LOGNAME /home/$LOGNAME/.tools
}

check_version(){
    term_color_red
    echo "Neovim version"
    term_color_white

    nvim -v
}

configure_runcom(){
    term_color_red
    echo "Configure runcom"
    term_color_white

    if [[ -f /usr/bin/nvim ]]; then
        sed -i '/#NVIM_0/c\export PATH=\$PATH:$HOME/.tools' /home/$LOGNAME/.shrc
    fi
}

install_plugins(){
    term_color_red
    echo "Install plugins"
    term_color_white

    nvim -c :PlugInstall
}

post(){
    echo
    echo "Done"
    echo

    # Do this in case of error - no python3 provider found
    # apt install python3-pynvim
}

trap term_color_white EXIT
confirmation
install_neovim
install_dependencies
update_configuration
check_version
configure_runcom
install_plugins
post
