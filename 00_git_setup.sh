#!/bin/bash

set -e

ID1="bus710"
COM1="gmail.com"
ID2="skim"
COM2="egnyte.com"
ID3="seongjun.kim"
COM3="deepspaceshipping.co"

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

cleanup(){
    term_color_red
    echo "Clean up"
    term_color_white

    rm -rf ~/.gitconfig
    rm -rf ~/repo/.gitconfig
    rm -rf ~/repo-egnyte/.gitconfig
    rm -rf ~/repo-satellite/.gitconfig
}

global_config(){
    term_color_red
    echo "Global configuration"
    term_color_white

    touch ~/.gitconfig

    git config remote.origin.url git@github.com:bus710/headless.git

    git config --global core.editor /usr/bin/nvim
    git config --global core.pager cat
    git config --global pull.rebase false
    git config --global push.default simple

    # this turns off pager config that works like the less command
    git config --global pager.branch false 

    # to include the config files conditionally
    # if there is no matching entry in ~/.ssh/config, 

    git config --global \
        includeIf.gitdir:~/repo/.path ~/repo/.gitconfig   
    # git config --global \
    #    url."git@github.com-bus710:bus710".insteadOf "git@github.com:bus710"

    # if there is no ssh config file, create one
    #SSH_CONFIG_FILE=/home/$LOGNAME/.ssh/config
    #if test -f $SSH_CONFIG_FILE; then
    #    echo ""
    #else 
    #    echo "Host github.com-bus710" >> $SSH_CONFIG_FILE
    #    echo "    HostName github.com" >> $SSH_CONFIG_FILE
    #    echo "    User git" >> $SSH_CONFIG_FILE
    #fi

    # git config --global \
    #    includeIf.gitdir:~/repo-egnyte/.path ~/repo-egnyte/.gitconfig
    # git config --global \
    #    url."ssh://git@git.egnyte-internal.com:".insteadOf "https://git.egnyte-internal.com"

    # git config --global \
    #    includeIf.gitdir:~/repo-satellite/.path ~/repo-satellite/.gitconfig
    # git config --global \
    #    url."git@github.com-satellite:skim-satellite".insteadOf "git@github.com:skim-satellite"
}

company_config(){
    term_color_red
    echo "Per company configuration"
    term_color_white

    mkdir -p ~/repo
    touch ~/repo/.gitconfig
    echo "[user]" >> ~/repo/.gitconfig
    echo "    name = bus710" >> ~/repo/.gitconfig
    echo "    email = ${ID1}@${COM1}" >> ~/repo/.gitconfig

    # mkdir -p ~/repo-egnyte
    # touch ~/repo-egnyte/.gitconfig
    # echo "[user]" >> ~/repo-egnyte/.gitconfig
    # echo "    name = SJ" >> ~/repo-egnyte/.gitconfig
    # echo "    email = ${ID2}@${COM2}" >> ~/repo-egnyte/.gitconfig

    # mkdir -p ~/repo-satellite
    # touch ~/repo-satellite/.gitconfig
    # echo "[user]" >> ~/repo-satellite/.gitconfig
    # echo "    name = SJ" >> ~/repo-satellite/.gitconfig
    # echo "    email = ${ID3}@${COM3}" >> ~/repo-satellite/.gitconfig
}

print_all(){
    term_color_red
    echo "Git config -l"
    term_color_white

    git config -l
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
global_config
company_config
print_all
post
