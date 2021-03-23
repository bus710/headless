#!/bin/bash

set -e

rm -rf ~/.gitconfig
rm -rf ~/repo/.gitconfig
rm -rf ~/repo-work/.gitconfig

touch ~/.gitconfig

git config remote.origin.url git@github.com:bus710/headless.git

git config --global core.editor /usr/bin/nvim
git config --global core.pager cat
git config --global pull.rebase false
git config --global push.default simple

# this turns off pager config that works like the less command
git config --global pager.branch false 

# to include the config files conditionally
git config --global includeIf.gitdir:~/repo/.path ~/repo/.gitconfig   
git config --global includeIf.gitdir:~/repo-work/.path ~/repo-work/.gitconfig
git config --global url."ssh://git@git.egnyte-internal.com:".insteadOf "https://git.egnyte-internal.com"

mkdir -p ~/repo
touch ~/repo/.gitconfig
echo "[user]" >> ~/repo/.gitconfig
echo "    name = bus710" >> ~/repo/.gitconfig
echo "    email = bus710@gmail.com" >> ~/repo/.gitconfig

mkdir -p ~/repo-work
touch ~/repo-work/.gitconfig
echo "[user]" >> ~/repo-work/.gitconfig
echo "    name = skim" >> ~/repo-work/.gitconfig
#echo "    email = skim@git.egnyte-internal.com" >> ~/repo-work/.gitconfig

# print

echo 
echo "Git config -l"
echo 

git config -l

