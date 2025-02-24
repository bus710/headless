#!/bin/bash

set -e

OS_TYPE=$(lsb_release -i)
ARCH_TYPE=$(uname -m)
NVIM_VERSION=""

if [[ "$EUID" == 0 ]]; then
	echo "Please run as normal user (w/o sudo)"
	exit
fi

term_color_red() {
	echo -e "\e[91m"
}

term_color_white() {
	echo -e "\e[39m"
}

confirmation() {
	term_color_red
	echo "This will delete nvim and your nvim config first"
	echo "Do you want to install? (y/n)"
	echo
	term_color_white

	echo
	read -n 1 ans
	echo

	if [[ ! $ans == "y" ]]; then
		exit 1
	fi
}

remove_previous_configuration() {
	term_color_red
	echo "Remove previous configuration"
	term_color_white

	rm -rf /home/$LOGNAME/.config/nvim.bak/nvim
	rm -rf /home/$LOGNAME/.config/nvim.bak

	# if [[ -d /home/$LOGNAME/.config/nvim ]]; then
	rm -rf /home/$LOGNAME/.config/nvim      #/home/$LOGNAME/.config/nvim.bak￼
	rm -rf /home/$LOGNAME/.local/share/nvim #/home/$LOGNAME/.local/share/nvim.bak
	rm -rf /home/$LOGNAME/.local/state/nvim #/home/$LOGNAME/.local/state/nvim.bak
	rm -rf /home/$LOGNAME/.cache/nvim       #/home/$LOGNAME/.cache/nvim.bak
	# fi
}

install_neovim() {
	HOME="/home/$LOGNAME"

	term_color_red
	echo "Install neovim"
	term_color_white

	sudo apt remove -y \
		neovim \
		neovim-runtime

	if [[ $OS_TYPE =~ "Ubuntu" ]]; then
		term_color_red
		echo "Add the neovim PPA for unstable"
		term_color_white

		sudo add-apt-repository ppa:neovim-ppa/unstable
		sudo apt update
		sudo apt install -y neovim

	elif [[ $OS_TYPE =~ "Debian" && $ARCH_TYPE =~ "x86_64" ]]; then
		term_color_red
		echo "Download the stable pre-built from Github"
		term_color_white

		mkdir -p /home/$LOGNAME/Downloads
		cd /home/$LOGNAME/Downloads


		# Sometimes it is better to use the one lower version than the stable version of NeoVim if there is any issue.
		# Please check the releases list.
		# https://github.com/neovim/neovim/releases

		wget -q \
			https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage \
			--output-document nvim

		# wget -v \
		#	https://github.com/neovim/neovim/releases/download/stable/nvim.appimage \
		#	--output-document nvim

		# wget -q \
		# 	https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage \
		# 	--output-document nvim

		# wget -q \
		# 	https://github.com/neovim/neovim/releases/download/v0.9.2/nvim.appimage \
		# 	--output-document nvim

		chmod +x nvim
		sudo chown root:root nvim
		sudo mv nvim /usr/bin

		cd -
	else
		term_color_red
		echo "Just install from the OS repo"
		term_color_white

		sudo apt install -y neovim
	fi

	term_color_red
	echo "Install required packages"
	term_color_white

	sudo apt install -y fuse3 libfuse2 ack-grep

	term_color_red
	echo "Clean up existing configuration"
	term_color_white

	rm -rf /home/$LOGNAME/.config/nvim/*
	rm -rf /home/$LOGNAME/.cache/nvim
	mkdir -p /home/$LOGNAME/.config/nvim
	mkdir -p /home/$LOGNAME/.tools

	term_color_red
	echo "Create a symlink"
	term_color_white

	sudo rm -rf /usr/bin/nv
	sudo ln -s /usr/bin/nvim /usr/bin/nv
}

install_dependencies() {
	term_color_red
	echo "Install nvim dependencies"
	term_color_white

	chown $LOGNAME:$LOGNAME /home/$LOGNAME/.cache -R

	# Got warning that says - externally managed environment
	# system wide python packages should be installed via apt
	#pip3 install --user -U testresources
	#pip3 install --user -U wheel
	#pip3 install --user -U setuptools --no-warn-script-location
	#pip3 install --user -U neovim
	#pip3 install --user -U pynvim

	sudo apt install -y \
		python3-testresources \
		python3-wheel \
		python3-setuptools \
		python3-neovim \
		python3-pynvim \
		python3.12-venv \
		luarocks
	npm install -g neovim

	sudo luarocks install luacheck
}

update_configuration() {
	term_color_red
	echo "Copy the config files and run the post process"
	term_color_white

	mkdir -p /home/$LOGNAME/.config/nvim/autoload
	mkdir -p /home/$LOGNAME/.config/nvim/plugged

	mkdir -p /home/$LOGNAME/.local
	mkdir -p /home/$LOGNAME/.tools

	curl -fLo /home/$LOGNAME/.config/nvim/autoload/plug.vim \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	cp init.vim /home/$LOGNAME/.config/nvim/init.vim
	cp ./coc-settings.json /home/$LOGNAME/.config/nvim/coc-settings.json

	chown -R $LOGNAME:$LOGNAME /home/$LOGNAME/.config
	chown -R $LOGNAME:$LOGNAME /home/$LOGNAME/.local
	chown -R $LOGNAME:$LOGNAME /home/$LOGNAME/.tools
}

check_version() {
	term_color_red
	echo "Neovim version"
	term_color_white

	nvim -v
}

configure_runcom() {
	term_color_red
	echo "Configure runcom"
	term_color_white

	if [[ -f /usr/bin/nvim ]]; then
		sed -i '/#NVIM_0/c\export PATH=\$PATH:$HOME/.tools' /home/$LOGNAME/.shrc
	fi
}

install_plugins() {
	term_color_red
	echo "Install plugins"
	term_color_white

	nvim -c :PlugInstall
}

post() {
	term_color_red
	echo "Done"
	term_color_white

	# Do this in case of error - no python3 provider found
	# apt install python3-pynvim
}

trap term_color_white EXIT
confirmation
remove_previous_configuration
install_neovim
install_dependencies
#update_configuration
check_version
configure_runcom
#install_plugins
post
