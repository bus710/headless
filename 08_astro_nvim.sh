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
		exit 1
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

		exit 1
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
		https://github.com/ClementTsang/bottom/releases/download/${BTM_VERSION}/bottom_${BTM_VERSION}-1_${ARCH_BTM}.deb

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
		rm -rf nerd-fonts
	fi

	git clone --filter=blob:none --sparse \
		https://github.com/ryanoasis/nerd-fonts.git

	cd nerd-fonts

	TARGET_FONTS=(
		"JetBrainsMono"
		"FiraMono"
		"FiraCode"
	)

	for F in "${TARGET_FONTS[@]}"; do
		term_color_red
		echo "Install ${F}"
		term_color_white

		git sparse-checkout add patched-fonts/${F} >/dev/null 2>&1
		./install.sh ${F} >/dev/null 2>&1
	done

	cd /home/$LOGNAME/repo/headless
	rm -rf /home/$LOGNAME/repo/nerd-fonts
}

remove_previous_installation() {
	term_color_red
	echo "Remove previous installation"
	term_color_white

	rm -rf /home/$LOGNAME/.config/nvim #/home/$LOGNAME/.config/nvim.bak￼
}

install_astro_nvim_v5() {
	term_color_red
	echo "Install AstroNvim (v5+)"
	term_color_white

	git clone --depth 1 \
		https://github.com/bus710/astronvim-template \
		/home/$LOGNAME/.config/nvim

	cd /home/$LOGNAME/.config/nvim
}

config_astro_nvim_v5() {
	# Config the user email
	NAME="bus710"
	git config user.email "$NAME@gmail.com"
	git remote set-url origin git@github.com:$NAME/astronvim-template
	cd -

	# Install plugins - TSInstall with ! enforces the installation without question
	nv --headless -c ':TSInstall! elixir' -c 'quitall'
	nv --headless -c ':TSInstall! heex' -c 'quitall'
	nv --headless -c ':TSInstall! eex' -c 'quitall'

	# nv --headless -c ':LspInstall emmet_ls' -c 'quitall'
	# nv --headless -c ':LspInstall tailwindcss' -c 'quitall'
	# nv --headless -c ':LspInstall elixirls' -c 'quitall' # Never do this as the elixir-tools takes case of it

	# npm install -g @tailwindcss/language-server # Done by another script

	# To monitor the lsp log in realtime
	# tail -f ~/.local/state/nvim/lsp.log
}

post() {
	term_color_red
	echo
	echo "Done"
	echo "- Please run \":Copilot auth\" to authenticate copilot"
	term_color_white
}

trap term_color_white EXIT
confirmation
install_utils
install_tree_sitter
install_lazygit
install_btm
install_nerd_fonts
remove_previous_installation
install_astro_nvim_v5
config_astro_nvim_v5
post
