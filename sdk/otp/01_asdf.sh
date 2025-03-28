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
    echo "ASDF clean install"
    echo "Do you want to proceed? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo ""
        exit 1
    fi
}

remove_asdf(){
    term_color_red
    echo "Remove ASDF"
    term_color_white
    
    rm -rf $HOME/.asdf
}

install_asdf(){
    term_color_red
    echo "Install ASDF"
    term_color_white
    
    TARGET_ASDF_VERSION=$(curl -o- -s https://api.github.com/repos/asdf-vm/asdf/releases/latest | jq -r '.tag_name')
    # git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $TARGET_ASDF_VERSION
    go install github.com/asdf-vm/asdf/cmd/asdf@${TARGET_ASDF_VERSION}
}

configure_rc(){
    term_color_red
    echo "Configure RC"
    term_color_white
   
    sed -i '/#ASDF_0/c\\texport PATH=${ASDF_DATA_DIR:-$HOME\/.asdf}\/shims:$PATH' $HOME/.shrc
    sed -i '/#ASDF_1/c\\tfpath=($HOME\/.asdf\/completions $fpath)' $HOME/.shrc
    sed -i '/#ASDF_2/c\\tautoload -Uz compinit && compinit' $HOME/.shrc

    mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
    asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
}

post(){
    term_color_red
    echo "Done"
    echo "- Restart terminal & try \"asdf --version\""
    term_color_white
}

trap term_color_white EXIT
confirmation
remove_asdf
install_asdf
configure_rc
post

