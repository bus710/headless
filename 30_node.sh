#!/bin/bash

set -e

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
        exit 1
    fi
}

install_nvm(){
    term_color_red
    echo "Install nvm"
    term_color_white

    TARGET_NVM_VERSION=$(curl -o- -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r '.tag_name')
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${TARGET_NVM_VERSION}/install.sh | bash

    term_color_red
    echo "Get ENV"
    term_color_white

    if [[ -d $HOME/.nvm ]]; then
        export NVM_DIR="$HOME/.nvm"
    else
        export NVM_DIR="$HOME/.config/nvm"
    fi

    # This loads nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    # This loads nvm bash_completion
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  
}

install_node_lts(){
    term_color_red
    echo "Install nodejs LTS"
    term_color_white

    nvm install --lts
}

post(){
    term_color_red
    echo "Done"
    echo "- restart terminal"
    echo "- global npm packages are installed by 40_sdk_tools.sh"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_nvm
install_node_lts
post
