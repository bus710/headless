#!/bin/bash

set -e

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation () {
    term_color_red
    echo "Make sure code and code-insiders are installed (y/n)"
    term_color_white

    echo
    read -n 1 ans 
    echo
    if [[ ! $ans == "y" ]]; then
        exit
    fi
}

cleanup () {
    term_color_red
    echo "Cleanup"
    term_color_white

    rm -rf /home/$LOGNAME/.vscode/extensions
    rm -rf /home/$LOGNAME/.vscode-insiders/extensions
}

install () {
    term_color_red
    echo "Install"
    term_color_white

    extensions=(
        # Git
        "eamodio.gitlens"
        "mhutchie.git-graph"
        # Error
        "usernamehw.errorlens"
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

        # Svelte
        "svelte.svelte-vscode"
        "ardenivanov.svelte-intellisense"
        # HTML
        "peakchen90.open-html-in-browser"
        # Tailwind
        "bradlc.vscode-tailwindcss"
        "austenc.tailwind-docs"

        # Erlang
        "erlang-ls.erlang-ls"

        # Zig
        #"webfreak.debug"
        #"tiehuis.zig"
        #"AugusteRame.zls-vscode"

        # Flutter
        #"Dart-Code.dart-code" 
        #"Dart-Code.flutter"

        # Python
        #"ms-python.python"

        # JS
        #"msjsdiag.debugger-for-chrome" # became built-in
        #"eg2.vscode-npm-script"

        # Arduino/RPI-Pico/ESP32
        "vsciot-vscode.vscode-arduino"
        #"marus25.cortex-debug"
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
        term_color_red
        echo Install $e
        term_color_white

        code --install-extension $e 2> /dev/null

        if [[ -f /usr/bin/code-insiders ]]; then
            code-insiders --install-extension $e 2> /dev/null
        fi
    done

    echo
}

post () {
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
cleanup
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



