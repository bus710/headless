#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]
then echo "Please run as normal user (w/o sudo)"
  exit
fi

echo
echo -e "\e[91m"
echo "Make sure code and code-insiders are installed (y/n)"
echo -e "\e[39m"

echo
read -n 1 ans 
echo

if [[ $ans == "y" ]]
then 
    extensions=(
        "vscodevim.vim"
        "dracula-theme.theme-dracula"
        "golang.Go"
        "Dart-Code.dart-code" 
        "Dart-Code.flutter"
        "redhat.vscode-yaml"
        "be5invis.toml"
        "ms-azuretools.vscode-docker"
        "ms-vscode-remote.remote-ssh"
        "ms-vscode-remote.remote-ssh-edit"
        "yzhang.markdown-all-in-one"
        "yzane.markdown-pdf"
        "liximomo.sftp"
        #"ms-vscode.cpptools"
        #"matklad.rust-analyzer"
        #"serayuzgur.crates"
        #"vadimcn.vscode-lldb"
    )

    for e in ${extensions[@]}; do
        echo
        echo -e "\e[91m"
        echo Install $e
        echo -e "\e[39m"
        code --install-extension $e
        code-insiders --install-extension $e
    done

    echo
fi

echo
