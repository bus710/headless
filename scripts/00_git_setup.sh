#!/bin/bash

set -e

git config remote.origin.url git@github.com:bus710/headless.git

git config --global core.editor /home/${LOGNAME}/.tools/nvim
git config --global core.pager cat
git config --global pull.rebase false
git config --global push.default simple

# this turns off pager config that works like the less command
git config --global pager.branch false 

# to include the config files conditionally
CONFIG=$(cat ~/.gitconfig)
git config --global includeif.gitdir:~/repo/.path ~/repo/.gitconfig   
git config --global includeif.gitdir:~/repo-work/.path ~/repo-work/.gitconfig
git config --global url."ssh://git@git.egnyte-internal.com:".insteadOf "https://git.egnyte-internal.com"

mkdir -p ~/repo
touch ~/repo/.gitconfig
mkdir -p ~/repo-work
touch ~/repo-work/.gitconfig

git config --file=~/repo/.gitconfig --add user.name bus710
git config --file=~/repo/.gitconfig --add user.email bus710@gmail.com

git config --file=~/repo-work/.gitconfig --add user.name skim
git config --file=~/repo-work/.gitconfig --add user.email skim@git.egnyte-internal.com

# print

echo 
echo "Git config -l"
echo 

git config -l
