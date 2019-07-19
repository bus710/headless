#!/bin/bash

echo 
echo "Clean up first"
echo 

sudo apt remove neovim
sudo rm /usr/bin/nvim /usr/bin/nvim.appimage
rm -rf ~/.config/nvim/*

echo 
echo "Install neovim and packages"
echo

curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/bin/nvim.appimage
sudo ln -s /usr/bin/nvim.appimage /usr/bin/nvim 

sudo apt install -y fuse libfuse2 ack-grep 
sudo apt install -y python3-pip
sudo apt install -y python-pip

pip install --user neovim
pip3 install --user neovim

echo 
echo "Copy the config files and run the post processor"
echo 

mkdir ~/.config/nvim
mkdir ~/.config/nvim/autoload
mkdir ~/.config/nvim/plugged

curl -fLo ~/.config/nvim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp init.vim ~/.config/nvim/init.vim

nvim -v

echo
echo "Run :PlugInstall"
echo

# TODO: airline installation
