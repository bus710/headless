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

confirmation() {
	term_color_red
	echo "The code and code-insiders should be installed (y/c/n)"
	echo "- y: install if not installed"
	echo "- c: clear the extension directory"
	echo "- n: cancel this script"
	term_color_white

	echo
	read -n 1 -r ans
	echo
	if [[ ! $ans == "y" ]] && [[ ! $ans == "c" ]]; then
		exit
	fi

	if [[ $ans == "c" ]]; then
		cleanup
	fi
}

cleanup() {
	term_color_red
	echo "Cleanup"
	term_color_white

	rm -rf /home/"$LOGNAME"/.vscode/extensions
	rm -rf /home/"$LOGNAME"/.vscode-insiders/extensions
}

install() {
	term_color_red
	echo "Install"
	term_color_white

	extensions=(
		# Git
		# "eamodio.gitlens"
		"mhutchie.git-graph"
		# Error
		"usernamehw.errorlens"
		# Editor
		"vscodevim.vim"
		"dracula-theme.theme-dracula"
		# ssh/docker
		"ms-vscode-remote.remote-ssh"
		"ms-vscode-remote.remote-ssh-edit"
		"ms-vscode-remote.remote-containers"
		"ms-azuretools.vscode-docker"
		# Config files
		"redhat.vscode-yaml"
		"tamasfe.even-better-toml"
		"zxh404.vscode-proto3"
		# PDF and markdown files
		"yzhang.markdown-all-in-one"
		"yzane.markdown-pdf"
		"tomoki1207.pdf"
		# C
		"ms-vscode.cpptools"
		"ms-vscode.cpptools-extension-pack"
		"ms-vscode.cmake-tools"
		"ms-vscode.makefile-tools"
		# Go
		"golang.Go"
		# Rust
		"rust-lang.rust-analyzer"
		"serayuzgur.crates"
		"vadimcn.vscode-lldb"
		"tauri-apps.tauri-vscode"

		# JS/Node
		"christian-kohler.npm-intellisense"
		"dbaeumer.vscode-eslint"
		"rvest.vs-code-prettier-eslint"

		# Svelte
		"svelte.svelte-vscode"
		"ardenivanov.svelte-intellisense"
		
		# Tailwind
		"bradlc.vscode-tailwindcss"
		"austenc.tailwind-docs"

		# Python and MicroPython
		"ms-python.python"
		"ms-python.vscode-pylance"
		# "paulober.pico-w-go"
		# "visualstudioexptteam.vscodeintellicode"

		# Erlang
		#"erlang-ls.erlang-ls"

		# Elixir
		# "JakeBecker.elixir-ls"
		# "benvp.vscode-hex-pm-intellisense"
		# "pantajoe.vscode-elixir-credo"
		# "phoenixframework.phoenix"
		# "Ritvyk.heex-html"
		# "animus-coop.vscode-elixir-mix-formatter"

		# Arduino
		"vsciot-vscode.vscode-arduino"
		# ARM
		"marus25.cortex-debug"
		# ESP32
		# "espressif.esp-idf-extension"

		# =====================================

		# SFTP
		# "Natizyskunk.sftp"
		
		# Zig
		# "webfreak.debug"
		# "ziglang.vscode-zig"

		# Flutter
		# "Dart-Code.dart-code"
		# "Dart-Code.flutter"

		# React
		# "dsznajder.es7-react-js-snippets"
		# "planbcoding.vscode-react-refactor"
		# "jeremyrajan.react-component"
		# "msjsdiag.vscode-react-native"	

		# Alpine
		# "adrianwilczynski.alpine-js-intellisense"
	)

	term_color_red
	echo "Prep the params"
	term_color_white

	PARAM=""
	for e in "${extensions[@]}"; do
		PARAM+=" --install-extension "$e
	done

	if [[ -f /usr/bin/code ]]; then
		code $PARAM 2>/dev/null
	fi

	if [[ -f /usr/bin/code-insiders ]]; then
		code-insiders $PARAM "$e" 2>/dev/null
	fi
	echo
}

post() {
	term_color_red
	echo "Done"
	term_color_white
}

trap term_color_white EXIT
confirmation
# cleanup
install
post

# VSCODE global configuration
# $HOME/.config/Code/User/settings.json
# $HOME/.config/'Code - Insiders'/User/settings.json

# {
#     "workbench.startupEditor": "newUntitledFile",
#     "workbench.sideBar.location": "right",
#     "workbench.colorTheme": "Dracula",
#     "editor.fontSize": 16,
#     "editor.minimap.enabled": false,
#     "git.enableSmartCommit": true,
#     "git.autofetch": true,
#     "go.toolsManagement.autoUpdate": true,
#     "terminal.integrated.fontSize": 16
# }
