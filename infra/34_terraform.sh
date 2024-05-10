#!/bin/bash

set -e

CPU_TYPE=$(uname -m)
ARCH=""
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
    term_color_red
    echo "Check the architecture"
    term_color_white

    if [[ $CPU_TYPE != "x86_64" ]] && [[ $CPU_TYPE != "aarch64" ]]; then
        term_color_red
        echo "This is not x86_64 or aarch64."
        term_color_white

        exit 1
    fi

    if [[ $CPU_TYPE == "x86_64" ]]; then
        ARCH="amd64"
    elif [[ $CPU_TYPE == "aarch64" ]]; then
        ARCH="arm64"
    fi

    term_color_red
    echo "TARGET CPU TYPE: $TARGET_CPU_TYPE"
    term_color_white
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
        exit 1
    fi

    sudo echo
}

install_terraform_bin(){
    term_color_red
    echo "Install terraform binary"
    term_color_white

    sudo rm -rf /usr/local/bin/terraform
    mkdir /home/$LOGNAME/Downloads/terraform_tmp
    cd /home/$LOGNAME/Downloads/terraform_tmp

    TARGET_VERSION=$(curl -o- -s https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name')
    TARGET_VERSION_WITHOUT_V=$(echo $TARGET_VERSION | sed 's/[^0-9.]*//g')
    FILE_NAME=terraform_${TARGET_VERSION_WITHOUT_V}_linux_${ARCH}.zip

    term_color_red
    echo "TARGET VERSION: ${TARGET_VERSION}"
    echo "FILE_NAME: ${FILE_NAME}"
    term_color_white

    wget https://releases.hashicorp.com/terraform/${TARGET_VERSION_WITHOUT_V}/${FILE_NAME}
    unzip ${FILE_NAME}

    sudo mv terraform /usr/local/bin
    cd -
    rm -rf /home/$LOGNAME/Downloads/terraform_tmp

}

configure_runcom(){
    term_color_red
    echo "Add autocompletion in zshrc"
    echo "These lines will be added to /\$HOME/.shrc"
    echo "- autoload -U +X bashcompinit && bashcompinit"
    echo "- complete -o nospace -C /usr/local/bin/terraform terraform"
    term_color_white

    if [[ -f /usr/local/bin/terraform ]]; then
        sed -i '/#TERRAFORM_0/c\autoload -U +X bashcompinit && bashcompinit' /home/$LOGNAME/.shrc
        sed -i '/#TERRAFORM_1/c\complete -o nospace -C \/usr\/local\/bin\/terraform terraform' /home/$LOGNAME/.shrc
    fi

    source /home/$LOGNAME/.shrc
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
check_architecture
confirmation
install_terraform_bin
configure_runcom
post


# ==================================================== 
# For Debian non-Sid, the official repo can be used
# Please Use the functions below in this order
# - check_architecture
# - confirmation
# - cleanup
# - install_prerequisites
# - install_gpg_key
# - verify_fingerprint
# - add_repo
# - install_terraform
# - configure_runcom
# - post
# ==================================================== 

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
    echo "Check if the finger print matches to the line below? (y/n)"
    echo "- 798A EC65 4E5C 1542 8C8E 42EE AA16 FCBC A621 E701"
    echo "- E8A0 32E0 94D8 EB4E A189 D270 DA41 8C88 A321 9F7B"
    echo "- or Google it with \"Terraform Linux package checksum verification\""
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        sudo rm -rf $GPG_KEY_PATH
        sudo rm -rf $REPO_PATH
        exit 1
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
