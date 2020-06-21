#!/bin/bash

git config remote.origin.url git@github.com:bus710/headless.git

git config user.email "bus710@gmail.com"
git config user.name "bus710"
git config push.default simple

git config --global user.email "bus710@gmail.com"
git config --global user.name "bus710"
git config --global push.default simple
git config --global core.editor nvim

# this turns off pager config that works like the less command
git config --global pager.branch false 

echo 
echo "Git config -l"
echo 

git config -l
