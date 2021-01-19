#!/bin/bash

set -e

git config remote.origin.url git@github.com:bus710/headless.git

git config user.email "bus710@gmail.com"
git config user.name "bus710"
git config push.default simple
git config pull.rebase false

#git config --global user.email "bus710@gmail.com"
#git config --global user.name "bus710"
git config --global push.default simple
git config --global core.editor /home/${LOGNAME}/.tools/nvim
git config --global core.pager cat
git config --global pull.rebase false

# this turns off pager config that works like the less command
git config --global pager.branch false 

# to include the config files conditionally
CONFIG=$(cat ~/.gitconfig)
if [[ $CONFIG =~ "includeIf" ]]; then
  echo "The config already has some includeIf section"
else
  echo "The config doesn't have any includeIf section"
  echo '[includeIf "gitdir:~/repo/"]' >> ~/.gitconfig
  echo "    path = ~/repo/.gitconfig" >> ~/.gitconfig
  echo "" >> ~/.gitconfig
  echo '[includeIf "gitdir:~/repo-work/"]' >> ~/.gitconfig
  echo "    path = ~/repo-work/.gitconfig" >> ~/.gitconfig
  echo "" >> ~/.gitconfig

  # create files
  mkdir -p ~/repo
  touch ~/repo/.gitconfig
  echo "[user]" >> ~/repo/.gitconfig
  echo "    name = bus710" >> ~/repo/.gitconfig
  echo "    email = bus710@gmail.com" >> ~/repo/.gitconfig
  mkdir -p ~/repo-work
  touch ~/repo-work/.gitconfig
  echo "[user]" >> ~/repo-work/.gitconfig
  echo "    name = Seongjun Kim" >> ~/repo-work/.gitconfig
  echo "    email = skim@egnyte.com" >> ~/repo-work/.gitconfig
fi

# print

echo 
echo "Git config -l"
echo 

git config -l
