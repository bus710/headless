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
    echo "Install PostgreSQL"
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ANSWER
    echo

    if [[ ! $ANSWER == "y" ]]; then
        exit -1
    fi
    sudo echo ""
}

install_postgresql(){
    term_color_red
    echo "Install PostgreSQL"
    term_color_white

    sudo apt install -y \
        postgresql \
        postgresql-contrib \
        postgresql-client 
}

post_install(){
    term_color_red
    echo "Post install - some commands"
    term_color_white

    echo "- PSQL shell: sudo -u postgres psql"
    echo "- # \\password postgres (or \$ACCOUNT_NAME)"
    echo "- # CREATE DATABASE pento_dev; (or \$DB_NAME)"
    echo "- # \\l"
    echo "- # \\q"
    echo
    echo "- To stop: sudo systemctl stop postgresql.service"
}


trap term_color_white EXIT
confirmation
install_postgresql
post_install

echo
echo "Done"
echo
