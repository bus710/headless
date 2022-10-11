#!/bin/bash

# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html

set -e

CPU_TYPE=$(uname -m)
URL="https://awscli.amazonaws.com/awscli-exe-linux-${CPU_TYPE}.zip"
FILE_NAME="awscliv2.zip"

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
    if [[ $CPU_TYPE != "x86_64" ]] || [[ $CPU_TYPE != "aarch64" ]]; then
        term_color_red
        echo
        echo "This is not x86_64 or aarch64."
        echo
        term_color_white

        exit -1
    fi
}

cleanup(){
    term_color_red
    echo
    echo "Remove if exist"
    echo
    term_color_white

    sudo rm -rf /usr/local/aws-cli
    sudo rm -rf /usr/local/bin/aws
    sudo rm -rf /usr/local/bin/aws_completer
}

install_sdk(){
    term_color_red
    echo
    echo "Get the package"
    echo
    term_color_white

    curl $URL -o $FILE_NAME

    term_color_red
    echo
    echo "Unzip..."
    echo
    term_color_white

    unzip $FILE_NAME

    term_color_red
    echo 
    echo "Install aws"
    echo
    term_color_white

    sudo ./aws/install

    term_color_red
    echo
    echo "Check the version"
    echo
    term_color_white

    aws --version
}

configure_runcom(){
    term_color_red
    echo
    echo "Add completer to path"
    echo 
    term_color_white

    if [[ -f /usr/local/bin/aws ]]; then
        sed -i '/#AWS_0/c\autoload bashcompinit && bashcompinit' /home/$LOGNAME/.shrc
        sed -i '/#AWS_1/c\complete -C \"\/usr\/local\/bin\/aws_completer\" aws' /home/$LOGNAME/.shrc
        sed -i '/#AWS_2/c\export PATH=\/usr\/local\/bin\/aws_completer:\$PATH' /home/$LOGNAME/.shrc
    fi
}

post(){
    term_color_red
    echo
    echo "Done"
    echo
    term_color_white
}

trap term_color_white EXIT
cleanup
install_sdk
configure_runcom
post