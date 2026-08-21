#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then
	echo "Please run as normal user (w/o sudo)"
	exit
fi

GLEAM_VERSION=""

term_color_red() {
	echo -e "\e[91m"
}

term_color_white() {
	echo -e "\e[39m"
}

register_repo() {
	term_color_red
	echo "Register repo"
	term_color_white

	if [[ ! -d /home/$LOGNAME/.asdf/plugins/gleam ]]; then
		asdf plugin add gleam 
	fi

	# How to get Gleam versions?
	# https://asdf-vm.com/manage/versions.html
	# Try "asdf list all gleam " for example

	GLEAM_VERSION=$(curl -fsSL https://api.github.com/repos/gleam-lang/gleam/releases/latest)
	GLEAM_VERSION=$(echo $GLEAM_VERSION | jq -r '.tag_name' | sed "s/v//g")
}

confirmation() {
	term_color_red
	echo "Install Erlang via ASDF"
	echo "Do you want to install? (y/n)"
	echo "- Gleam: $GLEAM_VERSION"
	term_color_white

	echo
	read -n 1 -r ANSWER
	echo

	if [[ ! $ANSWER == "y" ]]; then
		exit 1
	fi
	echo ""
	sudo echo ""
}

install_gleam() {
	term_color_red
	echo "Install gleam"
	term_color_white

	asdf install gleam "$GLEAM_VERSION"

	# Add the tool version
	if [[ -f /home/$LOGNAME/.tool-versions ]]; then
		TV=$(cat /home/$LOGNAME/.tool-versions | grep gleam | wc -m)
		if [[ $TV != "0" ]]; then
			sed -i '/gleam/c\ ' /home/$LOGNAME/.tool-versions
		fi
	fi
	echo "gleam $GLEAM_VERSION" >> /home/$LOGNAME/.tool-versions
}

check_installed_versions() {
	term_color_red
	echo "Check installed versions"
	term_color_white

	asdf current
	rebar3 --version
}

post() {
	term_color_red
	echo "Done"
	echo "- Make sure ~/.config/rebar3/rebar.config exists."
	term_color_white
}

trap term_color_white EXIT
register_repo
confirmation
install_gleam
check_installed_versions
post

