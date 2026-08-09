#!/bin/bash

set -e

URL=https://go.dev/VERSION\?m\=text
CPU_TYPE=$(uname -m)
CPU_TARGET=""
FULL_VERSION=""

if [[ "$EUID" == 0 ]];
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
    echo "Do you want to install few TUI tools? (y/n)"
    echo "- https://github.com/jesseduffield/lazygit"
    echo "- https://github.com/yorukot/superfile"
    echo "- https://github.com/tconbeer/harlequin"
    echo "- https://github.com/robertpsoane/ducker"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo ""
        exit 1
    fi
}

cleanup(){
    term_color_red
    echo "Existing executables will be removed"
    term_color_white

    sudo bash -c "rm -rf /usr/local/lazygit"
    sudo bash -c "rm -rf /usr/local/superfile"
}

install_lazygit(){
    term_color_red
    echo "Download and install LazyGit"
    term_color_white

    cd /home/$LOGNAME/Downloads
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm -rf lazygit*
    cd -
}

install_superfile(){
    term_color_red
    echo "Download and install SuperFile"
    term_color_white

    bash -c "$(wget -qO- https://raw.githubusercontent.com/yorukot/superfile/main/install.sh)"
}

install_harlequin(){
    term_color_red
    echo "Install Harlequin"
    term_color_white

    sudo apt install -y \
        pipx

    pipx uninstall harlequin # so the $HOME/.local/share/pipx cache can be cleaned up
    pipx install harlequin
    pipx inject harlequin harlequin-postgres

    # https://harlequin.sh/docs/getting-started
    #
    # How to connect to a DB
    # - If Postgresql is running in localhost
    # - The DB name is demo_dev
    # - The port is 5501 (the default is 5432)
    # - The ID/PW are postgres/postgres
    #
    # 1. With Postgres DSN
    # harlequin -a postgres \
    #           "postgres://${USER-ID}:${PASSWORD}@localhost:5501/${DB-NAME}"
    #
    # 2. With params
    # harlequin -a postgres \
    #           -h localhost \
    #           -p 5501 \
    #           -U postgres \
    #           --password postgres \
    #           -d demo_dev
    #
    # How to read a table "user" in the demo_dev DB
    # select * from public.user;

}

install_ducker(){
    term_color_red
    echo "Install Ducker"
    term_color_white

    if [[ -f /home/$LOGNAME/.cargo/bin/cargo ]]; then
        cargo install --git https://github.com/robertpsoane/ducker
    else
        echo "No cargo found"
    fi
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
cleanup
install_lazygit
install_superfile
install_harlequin
install_ducker
post
