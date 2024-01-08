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
        exit 1
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

install_harlequin(){
    term_color_red
    echo "Install Harlequin"
    term_color_white

    # https://harlequin.sh/docs/getting-started
    
    sudo apt install -y \
        pipx

    pipx install harlequin
    pipx inject harlequin harlequin-postgres
}

post_install(){
    term_color_red
    echo "Post install - some commands"
    term_color_white

    echo "- To check: sudo systemctl status postgresql"
    echo
    echo "- To start PSQL shell: sudo -u postgres psql"
    echo
    echo "- # \\password postgres (or \$ACCOUNT_NAME)"
    echo "- # CREATE DATABASE test; (or \$DB_NAME)"
    echo "- # \\c test"
    echo "- # CREATE TABLE IF NOT EXISTS users ("
    echo "      id SERIAL PRIMARY KEY,"
    echo "      age INT,"
    echo "      first_name TEXT,"
    echo "      last_name TEXT,"
    echo "      email TEXT UNIQUE NOT NULL);"
    echo "- # DROP DATABASE test; (or \$DB_NAME)"
    echo 
    echo "- # \\l (list DBs)"
    echo "- # \\c (change DB)"
    echo "- # \\e (edit a query)"
    echo "- # \\dt (list tables)"
    echo "- # \\d (see relation)"
    echo "- # \\d+ (see relation with details)"
    echo "- # \\d \$TABLE_NAME (describe the table)"
    echo "- # \\dn (list all schemas)"
    echo "- # \\dv (list all views)"
    echo "- # \\du (list all users)"
    echo "- # \\df (list all functions)"
    echo "- # \\db (list all table space)"
    echo "- # \\q (quit)"
    echo
    echo "- To stop: sudo systemctl stop postgresql.service"
}


trap term_color_white EXIT
confirmation
install_postgresql
install_harlequin
post_install

echo
echo "Done"
echo
