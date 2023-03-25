#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
    exit
fi

echo
echo "ASDF clean install"
echo

sudo echo ""

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
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
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $TARGET_ASDF_VERSION
}

configure_rc(){
    term_color_red
    echo "Congirue RC"
    term_color_white
    
    sed -i '/#ASDF_0/c\. $HOME\/.asdf\/asdf.sh' $HOME/.shrc
    sed -i '/#ASDF_1/c\fpath=($HOME\/.asdf\/completions $fpath)' $HOME/.shrc
    sed -i '/#ASDF_2/c\autoload -Uz compinit && compinit' $HOME/.shrc
}

post(){
    term_color_red
    echo "Done"
    echo "- Restart terminal & try \"asdf --version\""
    term_color_white
}

trap term_color_white EXIT
remove_asdf
install_asdf
configure_rc
post

