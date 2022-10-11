#!/bin/bash

set -e

CPU_TYPE=$(uname -m)
CPU_TARGET=""

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
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
    echo "Please check the website if there is a new NVM version"
    echo "- https://github.com/nvm-sh/nvm/releases"
    echo 
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        exit -1
    fi
}

check_architecture(){
    if [[ $CPU_TYPE == "x86_64" ]]; then
        CPU_TARGET="amd64" 
    elif [[ $CPU_TYPE == "aarch64" ]]; then
        CPU_TARGET="arm64"
    else
        exit
    fi
}

install_nvm(){
    term_color_red
    echo
    echo "Install nvm"
    echo
    term_color_white

    TARGET_NVM_VERSION=$(curl -o- -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r '.tag_name')
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${TARGET_NVM_VERSION}/install.sh | zsh

    term_color_red
    echo
    echo "Get ENV"
    echo
    term_color_white

    export NVM_DIR="$HOME/.nvm"
    # This loads nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  
    # This loads nvm bash_completion
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  
}

install_node_lts(){
    term_color_red
    echo
    echo "Install nodejs LTS"
    echo
    term_color_white

    nvm install --lts

    #echo -e "\e[91m"
    #echo "Install packages"
    #echo -e "\e[39m"

    packages=(
        # npx comes with node/npm
        "yarn" # need for vim-elixir-coc
    )
    #    "degit"
    #    "typescript"

    #for p in ${packages[@]}; do
    #    echo -e "\e[91m"
    #    echo Install $p
    #    echo -e "\e[39m"

    #    npm install -no-fund -g $p
    #done
}

post(){
    term_color_red
    echo
    echo "Done"
    echo "- restart terminal"
    echo
    term_color_white
}

trap term_color_white EXIT
confirmation
check_architecture
install_nvm
install_node_lts
post
