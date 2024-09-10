#!/bin/bash

set -e

# This is splitted from Golang installation because 

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

install_packages(){
    term_color_red
    echo "Install packages"
    term_color_white

    # Internal tools
    go install -v golang.org/x/tools/cmd/goimports@latest
    go install -v golang.org/x/tools/cmd/callgraph@latest
    #go install -v golang.org/x/tools/cmd/digragh@latest
    go install -v golang.org/x/tools/cmd/stringer@latest
    go install -v golang.org/x/tools/cmd/toolstash@latest

    # Unit test
    go install -v github.com/cweill/gotests/gotests@latest

    # Debugger
    go install -v github.com/go-delve/delve/cmd/dlv@latest

    # Go exec (and its usage)
    # goexec 'http.ListenAndServe(":8080", http.FileServer(http.Dir(".")))'
    go install -v github.com/shurcooL/goexec@latest 

    go install github.com/sno6/gommand@latest
    # gommand 'http.Handle("/", http.FileServer(http.Dir("."))); \
    #   fmt.Println(http.ListenAndServe(":8080", nil))'

    # Bubble tea related
    go install -v github.com/maaslalani/slides@latest

    # Wails
    go install github.com/wailsapp/wails/v2/cmd/wails@latest

    # Nice to haves
    #go install github.com/hajimehoshi/wasmserve
    #go install github.com/swaggo/swag/cmd/swag
    #go install github.com/google/gops
}

install_vim_go_plugins(){
    term_color_red
    echo "Install vim-go plugins"
    term_color_white

    nvim -c :GoInstallBinaries
}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
install_packages
#install_vim_go_plugins
post
