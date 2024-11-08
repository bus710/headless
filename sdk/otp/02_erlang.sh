#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then
	echo "Please run as normal user (w/o sudo)"
	exit
fi

ERLANG_VERSION=""

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

	if [[ ! -d /home/$LOGNAME/.asdf/plugins/erlang ]]; then
		asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
	fi

	# How to get Erlang versions?
	# https://asdf-vm.com/manage/versions.html
	# Try "asdf list all erlang" for example

	# Please check the Elixir LS release note to make sure the compatibility
	# https://github.com/elixir-lsp/elixir-ls/releases

	# ERLANG_VERSION=$(asdf latest erlang)
	ERLANG_VERSION=$(asdf list all erlang 27 | tail -n1)

	# github API equivalent
	# curl -o- -s https://api.github.com/repos/erlang/otp/releases/latest | jq -r '.tag_name'
}

confirmation() {
	term_color_red
	echo "Install Erlang via ASDF"
	echo "Do you want to install? (y/n)"
	echo "- Erlang: $ERLANG_VERSION"
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

install_packages() {
	term_color_red
	echo "Install packages"
	term_color_white

	sudo apt install -y \
		build-essential \
		libncurses-dev \
		inotify-tools \
		libxml2-utils \
		unixodbc-dev \
		libssh-dev \
		automake \
		autoconf \
		xsltproc \
		fop \
		m4

	# Don't install these:
	# openjdk-17-jdk-headless
	# libodbc2
	# erlang-jinterface \
}

install_packages_for_wx_debugger() {
	term_color_red
	echo "Install packages for wx debugger"
	term_color_white

	sudo apt install -y \
		libwxgtk-webview3.2-dev \
		libwebkit2gtk-4."*"-dev \
		libglu1-mesa-dev \
		libgl1-mesa-dev \
		libwxgtk3.2-dev \
		libpng-dev
}

install_wxwidgets() {
	# https://github.com/erlang/otp/blob/master/HOWTO/INSTALL.md#building
	# https://github.com/erlang/otp/blob/master/HOWTO/INSTALL.md#Advanced-configuration-and-build-of-ErlangOTP_Building_Building-with-wxErlang

	# Don't execute this function if wxrc exists
	if [[ -f /usr/local/bin/wxrc ]]; then
		return
	fi

	term_color_red
	echo "Install wxwidgets"
	term_color_white

	cd /home/"$LOGNAME"/repo
	git clone --branch WX_3_0_BRANCH git@github.com:wxWidgets/wxWidgets.git

	# The configure takes the webview option, 
	# but erlang installation doesn't see this wx as webview enabled.
	cd wxWidgets
	./configure --prefix=/usr/local --enable-webview --enable-compat28 --with-gtk=3
	git submodule update --init src/png
	git submodule update --init src/jpeg

	# git submodule update --init src/stc/scintilla
	# git submodule update --init src/stc/lexilla
	# git submodule update --init 3rdparty/catch
	# git submodule update --init 3rdparty/nanosvg

	make -j4 && sudo make install
	export PATH=/usr/local/bin:$PATH

	sudo ldconfig

	# To make sure if wx is installed well.
	# sudo update-alternatives --config wx-config
	# which wx-config && wx-config --version-full
	# wx-config --list
	# wx-config --libs all
}

install_erlang() {
	term_color_red
	echo "Install erlang"
	term_color_white

	# https://github.com/erlang/otp/blob/master/HOWTO/INSTALL.md#building-and-installing-erlangotp
	# https://github.com/asdf-vm/asdf-erlang/issues/203#issuecomment-846602541
	export KERL_BUILD_DOCS=yes
	export KERL_USE_AUTOCONF=0
	# export KERL_CONFIGURE_OPTIONS="--disable-debug \
 	#        --enable-wx \
 	#        --with-wx \
 	#        --enable-webview \
 	#        --with-wx-config=/usr/local/bin/wx-config \
 	#        --without-javac \
 	#        --without-jinterface \
 	#        --without-odbc"
	export KERL_CONFIGURE_OPTIONS="--disable-debug \
		--without-wx \
        --without-javac \
        --without-jinterface \
        --without-odbc"
	asdf install erlang "$ERLANG_VERSION"
	asdf global erlang "$ERLANG_VERSION"

	# To put some arguments for the erl shell.
	sed -i '/#ERL_0/c\export ERL_AFLAGS=\"+pc unicode -kernel shell_history enabled\"' /home/$LOGNAME/.shrc
}

install_rebar3() {
	term_color_red
	echo "Install rebar3 (pre-built)"
	term_color_white

	wget -P /home/"$LOGNAME"/Downloads https://s3.amazonaws.com/rebar3/rebar3
	chmod +x /home/"$LOGNAME"/Downloads/rebar3

	sudo mkdir -p /usr/local/bin
	sudo rm -rf /usr/local/bin/rebar3
	sudo mv /home/"$LOGNAME"/Downloads/rebar3 /usr/local/bin
	# /usr/local/bin/rebar3 local install

	rm -rf /home/"$LOGNAME"/.config/rebar3/rebar.config
	mkdir -p /home/"$LOGNAME"/.config/rebar3
	echo "{plugins, [rebar3_hex]}." >>~/.config/rebar3/rebar.config
}

install_escript_symbol() {
	term_color_red
	echo "Install escript symbol"
	term_color_white

	# To help Erlang_LS vscode extention.
	# In SwayWM, the "bindsym => exec" shortcut doesn't pass the PATH to VSCODE.
	sudo rm -rf /usr/local/bin/escript
	sudo ln -s /home/"$LOGNAME"/.asdf/shims/escript /usr/local/bin/escript
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
install_packages
# install_packages_for_wx_debugger
# install_wxwidgets
install_erlang
install_rebar3
install_escript_symbol
check_installed_versions
post

# For future issues
# https://packages.debian.org/search?suite=default&section=all&arch=any&searchon=names&keywords=libwxgtk-webview
# https://packages.ubuntu.com/search?keywords=libwxgtk-webview&searchon=names&suite=all&section=all
