#!/bin/bash

set -e

OS_TYPE=$(lsb_release -i)
ARCH_TREE_SITTER=""
ARCH_LAZYGIT=""
ARCH_BTM=""

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
	echo "This will backup previous nvim configs and install AstroNvim config"
	echo "Do you want to install? (y/n)"
	echo
	term_color_white

	echo
	read -n 1 ans
	echo

	if [[ ! $ans == "y" ]]; then
		exit -1
	fi

	CPU_TYPE=$(uname -m)
	if [[ $CPU_TYPE != "x86_64" && $CPU_TYPE != "aarch64" ]]; then
		echo "x86_64 or aarch64 can be used."
		exit
	fi

	if [[ $CPU_TYPE == "x86_64" ]]; then
		ARCH_TREE_SITTER="x64"
		ARCH_LAZYGIT="x86_64"
		ARCH_BTM="amd64"
	elif [[ $CPU_TYPE == "aarch64" ]]; then
		ARCH_TREE_SITTER="arm64"
		ARCH_LAZYGIT="arm64"
		ARCH_BTM="arm64"
	else
		term_color_red
		echo "Don't know what the arch is"
		term_color_white

		exit -1
	fi
}

install_utils() {
	term_color_red
	echo "Install utils"
	term_color_white

	sudo apt install -y \
		ripgrep \
		gdu
}

install_tree_sitter() {
	term_color_red
	echo "Install tree-sitter"
	term_color_white

	cd /home/$LOGNAME/Downloads
	rm -rf tree-sitter*
	sudo rm -rf /usr/local/bin/tree-sitter

	TREE_SITTER_VERSION=$(curl -o- -s https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest | jq -r '.tag_name')
	echo "$TREE_SITTER_VERSION"

	wget -O tree-sitter.gz \
		https://github.com/tree-sitter/tree-sitter/releases/download/${TREE_SITTER_VERSION}/tree-sitter-linux-${ARCH_TREE_SITTER}.gz

	gzip -d tree-sitter.gz
	chmod 550 tree-sitter
	sudo mv tree-sitter /usr/local/bin

	cd -
}

install_lazygit() {
	term_color_red
	echo "Install lazygit"
	term_color_white

	cd /home/$LOGNAME/Downloads
	rm -rf lazygit*
	sudo rm -rf /usr/local/bin/lazygit

	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH_LAZYGIT}.tar.gz"

	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin
	rm -rf lazygit*

	cd -
}

install_btm() {
	term_color_red
	echo "Install btm"
	term_color_white

	cd /home/$LOGNAME/Downloads
	rm -rf bottom.deb
	sudo rm -rf /usr/local/bin/btm

	BTM_VERSION=$(curl -o- -s https://api.github.com/repos/ClementTsang/bottom/releases/latest | jq -r '.tag_name')
	echo "$BTM_VERSION"

	wget -O bottom.deb \
		https://github.com/ClementTsang/bottom/releases/download/${BTM_VERSION}/bottom_${BTM_VERSION}_${ARCH_BTM}.deb

	sudo dpkg -i bottom.deb
	rm -rf bottom.deb

	cd -
}

install_nerd_fonts() {
	term_color_red
	echo "Install nerd-fonts"
	term_color_white

	cd /home/$LOGNAME/repo

	if [[ -d nerd-fonts ]]; then
		echo
		echo "A nerd-fonts directory exists"
		echo
		return
	fi

	term_color_red
	echo "Cloning might take some time"
	term_color_white

	git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git

	cd nerd-fonts
	./install.sh

	cd -
}

backup_previous_configuration() {
	term_color_red
	echo "Backup previous configuration"
	term_color_white

	rm -rf /home/$LOGNAME/.config/nvim.bak/nvim

	if [[ -d /home/$LOGNAME/.config/nvim ]]; then
		rm -rf /home/$LOGNAME/.config/nvim      #/home/$LOGNAME/.config/nvim.bak￼
		rm -rf /home/$LOGNAME/.local/share/nvim #/home/$LOGNAME/.local/share/nvim.bak
		rm -rf /home/$LOGNAME/.local/state/nvim #/home/$LOGNAME/.local/state/nvim.bak
		rm -rf /home/$LOGNAME/.cache/nvim       #/home/$LOGNAME/.cache/nvim.bak
	fi
}

install_astro_nvim() {
	term_color_red
	echo "Install AstroNvim"
	term_color_white

	git clone --depth 1 https://github.com/AstroNvim/AstroNvim /home/$LOGNAME/.config/nvim
}

install_astro_nvim_config() {
	term_color_red
	echo "Install AstroNvim config"
	term_color_white

	if [[ ! -d /home/$LOGNAME/.config/nvim/lua ]]; then
		mkdir -p /home/$LOGNAME/.config/nvim/lua
	else
		rm -rf /home/$LOGNAME/.config/nvim/lua/user
	fi

	git clone git@github.com:bus710/astronvim-config.git /home/$LOGNAME/.config/nvim/lua/user

	# Config the user email
	cd /home/$LOGNAME/.config/nvim/lua/user
	NAME="bus710"
	git config user.email "$NAME@gmail.com"
	cd -

	# Install plugins
	nv --headless \
  	-c ':TSInstall elixir' \
  	-c ':TSInstall heex' \
  	-c ':TSInstall eex' \
  	-c ':LspInstall emmet-ls' \
  	-c ':LspInstall tailwindcss' \
  	-c 'quitall'
}

post() {
	echo
	echo "Done"
	echo
}

trap term_color_white EXIT
confirmation
install_utils
install_tree_sitter
install_lazygit
install_btm
install_nerd_fonts
backup_previous_configuration
install_astro_nvim
install_astro_nvim_config
post
