#!/bin/bash

echo
echo -e "\e[91m"
echo "Make sure code and code-insiders are installed (y/n)"
echo -e "\e[39m"

read -n 1 ans 
echo

if [ $ans == "y" ]
then 
    extensions=(
        "vscodevim.vim"
        "dracula-theme.theme-dracula"
        "ms-vscode.Go"
        "Dart-Code.dart-code" 
        "Dart-Code.flutter"
        "ms-azuretools.vscode-docker"
        "yzhang.markdown-all-in-one"
        "yzane.markdown-pdf"
        "ms-vscode-remote.remote-ssh"
        "ms-vscode-remote.remote-ssh-edit"
        "liximomo.sftp"
        "redhat.vscode-yaml"
        "bungcip.better-toml"
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
