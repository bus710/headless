#!/bin/bash

set -e

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo "Tauri scaffolding:"
    echo "- Tauri core will be added."
    echo
    echo "Do you want to proceed? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo ""
        exit -1
    fi

    IS_TAURI_EXIST=$(ls | grep src-tauri | wc -l)
    if [[ ! $IS_TAURI_EXIST == "0" ]]; then
        echo "There is a tauri directory already."
        exit -1
    fi
}

configure_vite(){
    term_color_red
    echo "Configure vite"
    term_color_white

    IS_CONFIG_EXIST=$(cat vite.config.js | grep clearScreen | wc -l)

    if [[ ! $IS_CONFIG_EXIST == "0" ]]; then
        echo "Config exists"
        return
    fi

    # Add these lines before "plugins:"
    # clearScreen: false,
    # server: {
    #   strictPort: true,
    # },
    # envPrefix: ['VITE_', 'TAURI_'],
    # build: {
    #   target: process.env.TAURI_PLATFORM == 'windows' ? 'chrome105' : 'safari13',
    #   minify: !process.env.TAURI_DEBUG ? 'esbuild' : false,
    #   sourcemap: !!process.env.TAURI_DEBUG,
    # },

    sed -i '/plugins:/i \'\
'clearScreen: false,\n'\
'server: { \n'\
'strictPort: true, \n'\
'}, \n'\
'envPrefix: \[\"VITE_\", \"TAURI_\"\], \n'\
'build: { \n'\
'target: process.env.TAURI_PLATFORM == \"windows\" ? \"chrome105\" : \"safari13\", \n'\
'minify: !process.env.TAURI_DEBUG ? \"esbuild\" : false, \n'\
'sourcemap: !!process.env.TAURI_DEBUG, \n},' vite.config.js
}

add_tauri(){
    term_color_red
    echo "Add tauri"
    echo "- Just use default values for now"
    term_color_white

    cargo tauri init
}

configure_tauri(){
    term_color_red
    echo "Configure tauri"
    term_color_white

    sed -i 's/8080/5173/' src-tauri/tauri.conf.json
    sed -i 's/public/dist/' src-tauri/tauri.conf.json
}
post(){
    term_color_red
    echo "Done"
    echo "Try \"cargo tauri dev\""
    echo "Add more commands and events"
    term_color_white
}

trap term_color_white EXIT
confirmation
configure_vite
add_tauri
configure_tauri
post

