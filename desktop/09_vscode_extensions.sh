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
        # Git
        "eamodio.gitlens"
        # Editor
        "vscodevim.vim"
        "dracula-theme.theme-dracula"
        # Go
        "golang.Go"
        # Flutter
        "Dart-Code.dart-code" 
        "Dart-Code.flutter"
        # remote/docker
        "ms-azuretools.vscode-docker"
        "ms-vscode-remote.remote-ssh"
        "ms-vscode-remote.remote-ssh-edit"
        "ms-vscode-remote.remote-containers"
        "liximomo.sftp"
        # Config files
        "redhat.vscode-yaml"
        "be5invis.toml"
        "yzhang.markdown-all-in-one"
        "yzane.markdown-pdf"
        # Rust
        #"matklad.rust-analyzer"
        #"serayuzgur.crates"
        #"vadimcn.vscode-lldb"
        # Embedded
        #"ms-vscode.cpptools"
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
