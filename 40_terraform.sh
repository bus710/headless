#!/bin/bash

set -e

CPU_TYPE=$(uname -m)
GPG_KEY_PATH="/usr/share/keyrings/hashicorp-archive-keyring.gpg"
REPO_PATH="/etc/apt/sources.list.d/hashicorp.list"

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

check_architecture(){
    if [[ $CPU_TYPE != "x86_64" ]] && [[ $CPU_TYPE != "aarch64" ]]; then
        term_color_red
        echo "This is not x86_64 or aarch64."
        term_color_white

        exit -1
    fi
}

confirmation(){
    term_color_red
    echo "Install HashiCorp Terraform"
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        exit -1
    fi

    sudo echo
}

install_prerequisites(){
    term_color_red
    echo "Install the prerequisites"
    term_color_white

    sudo apt install -y \
        gnupg \
        software-properties-common
}

cleanup(){
    term_color_red
    echo "Remove the gpg key from previous installation if exists"
    term_color_white

    sudo rm -rf $GPG_KEY_PATH
    sudo rm -rf $REPO_PATH
}

install_gpg_key(){
    term_color_red
    echo "Install a new gpg key"
    term_color_white

    wget -O- https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor | \
        sudo tee $GPG_KEY_PATH
}

verify_fingerprint(){
    term_color_red
    echo "Verify the fingerprint"
    term_color_white

    gpg --no-default-keyring \
        --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
        --fingerprint

    term_color_red
    echo "If the fingerprint matches to the line below? (y/n)"
    echo "- E8A0 32E0 94D8 EB4E A189  D270 DA41 8C88 A321 9F7B"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        sudo rm -rf $GPG_KEY_PATH
        sudo rm -rf $REPO_PATH
        exit -1
    fi
}

add_repo(){
    term_color_red
    echo "Add the repo"
    term_color_white

    sudo rm -rf $REPO_PATH

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee $REPO_PATH
}

install_terraform(){
    term_color_red
    echo "Install terraform"
    term_color_white

    sudo apt update
    sudo apt install -y terraform
}

configure_runcom(){
    term_color_red
    echo "Add autocompletion in zshrc"
    echo "These lines will be added to /\$HOME/.zshrc"
    echo "- autoload -U +X bashcompinit && bashcompinit"
    echo "- complete -o nospace -C /usr/bin/terraform terraform"
    term_color_white

    CHECK_RC=$(cat /home/$LOGNAME/.zshrc | grep /usr/bin/terraform)
    if [[ $CHECK_RC =~ "/usr/bin/terraform" ]]; then
        term_color_red
        echo "There is a related line in the runcom already - skip."
        term_color_white
    else 
        terraform -install-autocomplete
    fi
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
check_architecture
confirmation
cleanup
install_prerequisites
install_gpg_key
verify_fingerprint
add_repo
install_terraform
configure_runcom
post
