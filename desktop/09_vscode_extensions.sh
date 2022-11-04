#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
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
        "Natizyskunk.sftp"
        # Config files
        "redhat.vscode-yaml"
        "be5invis.toml"
        # PDF and markdown files
        "yzhang.markdown-all-in-one"
        "yzane.markdown-pdf"
        # C
        "ms-vscode.cpptools"
        "ms-vscode.makefile-tools"
        # Go
        "golang.Go"

        # Rust
        "rust-lang.rust-analyzer"
        "serayuzgur.crates"
        "vadimcn.vscode-lldb" 

        # Flutter
        "Dart-Code.dart-code" 
        "Dart-Code.flutter"
      
        # Zig
        #"webfreak.debug"
        #"tiehuis.zig"
        #"AugusteRame.zls-vscode"
        # Svelte
        #"svelte.svelte-vscode"
        #"ardenivanov.svelte-intellisense"
        # HTML
        #"peakchen90.open-html-in-browser"
        # Tailwind
        #"bradlc.vscode-tailwindcss"
        #"austenc.tailwind-docs"

        # Python
        #"ms-python.python"

        # JS
        #"msjsdiag.debugger-for-chrome" # became built-in
        #"eg2.vscode-npm-script"
        # Embedded
        #"marus25.cortex-debug"
        #"vsciot-vscode.vscode-arduino"
        #"espressif.esp-idf-extension"
        # Elm
        #"Elmtooling.elm-ls-vscode"

        # Elixir
        #"JakeBecker.elixir-ls"
        #"benvp.vscode-hex-pm-intellisense"
        #"pantajoe.vscode-elixir-credo"
        #"phoenixframework.phoenix"
        #"Ritvyk.heex-html"
        # AlpineJS
        #"adrianwilczynski.alpine-js-intellisense"
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

echo "done"

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

