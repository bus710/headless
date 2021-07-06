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
        "mhutchie.git-graph"
        # Editor
        "vscodevim.vim"
        "dracula-theme.theme-dracula"
        # remote/docker
        "ms-azuretools.vscode-docker"
        "ms-vscode-remote.remote-ssh"
        "ms-vscode-remote.remote-ssh-edit"
        "ms-vscode-remote.remote-containers"
        "liximomo.sftp"
        # Config files
        "redhat.vscode-yaml"
        "be5invis.toml"
        # PDF and markdown files
        "yzhang.markdown-all-in-one"
        "yzane.markdown-pdf"
        # Go
        "golang.Go"
        # Flutter
        "Dart-Code.dart-code" 
        "Dart-Code.flutter"
        # Rust
        "matklad.rust-analyzer"
        "serayuzgur.crates"
        "vadimcn.vscode-lldb"
        # Svelte
        "svelte.svelte-vscode"
        "ardenivanov.svelte-intellisense"
        "msjsdiag.debugger-for-chrome"
        "eg2.vscode-npm-script"
        # Elm
        #"Elmtooling.elm-ls-vscode"
        # Elixir
        #"JakeBecker.elixir-ls"
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
