#!/bin/bash

set -e

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

install_language_server() {
	# term_color_red
	# echo "install elixir-ls for nvim coc"
	# term_color_white
	#
	# cd ~/Downloads
	# LS_VERSION=$(curl -o- -s https://api.github.com/repos/elixir-lsp/elixir-ls/releases/latest | jq -r '.tag_name')
	# wget https://github.com/elixir-lsp/elixir-ls/releases/download/${LS_VERSION}/elixir-ls-${LS_VERSION}.zip \
	# 	-O elixir-ls.zip
	# unzip elixir-ls.zip -d /home/$LOGNAME/.config/nvim/plugged/coc-elixir/els-release
	# rm -rf /home/$LOGNAME/Downloads/elixir-ls.zip

	term_color_red
	echo "install and build elixir-ls for editors"
	term_color_white

	rm -rf /home/"$LOGNAME"/.elixir-ls
	git clone https://github.com/elixir-lsp/elixir-ls.git /home/"$LOGNAME"/.elixir-ls
	cd /home/"$LOGNAME"/.elixir-ls
	mix deps.get && mix compile && mix elixir_ls.release -o release

	cp VERSION scripts/
	./scripts/launch.sh
}

post() {
	term_color_red
	echo "Done"
	term_color_white
}

norun() {
	echo "elixir-tools nvim plugin installs elixir-ls by itself"
	exit
}

trap term_color_white EXIT
install_language_server
post
