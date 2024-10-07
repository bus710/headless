#!/bin/bash

set -e

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
    exit
fi

PROJECT_NAME=""

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo "It should be a node project directoy created by 'npm init -y'"
    echo "Check if there is a package.json"
    term_color_white

    if [[ ! -f package.json ]]; then
        echo "Not found"
        exit 1
    fi

    echo "Found it"
    echo
}

install(){
    term_color_red
    echo "Install"
    term_color_white

    echo
    pwd
    echo

    npx tsc --init

    # Test the regex if needed
    # sed -i -r '/^[ \t]*\//d; /^[[:space:]]*$/d; s/\/\*(.*?)\*\///g; s/[[:blank:]]+$//' tsconfig.json

    # Update tsconfig
    cat tsconfig.json | 
        sed -E -r '/^[ \t]*\//d; /^[[:space:]]*$/d; s/\/\*(.*?)\*\///g; s/[[:blank:]]+$//' |
        jq '.compilerOptions.rootDir = "./src"' |
        jq '.compilerOptions.outDir = "./dist"' > tsconfig.tmp
    cat tsconfig.tmp > tsconfig.json && rm -rf tsconfig.tmp

    # Update the main and required package
    cat package.json |
        jq '.main = "src/main.ts"' |
        jq '.scripts.dev = "npx tsx src/main.ts"' |
        jq '.scripts.build = "tsc"' > package.tmp
    cat package.tmp > package.json && rm -rf package.tmp

    # Also add typescript for restoring
    npm i --save-dev typescript

    # Add the main.ts file
    mkdir src
    echo 'console.log("hello");' > src/main.ts

    touch .gitignore
    echo 'package-lock.json' >> .gitignore
    echo 'node_modules' >> .gitignore
    echo 'dist' >> .gitignore
}

post(){
    term_color_red
    echo "Done"
    echo "- git init --initial-branch=main"
    term_color_white
}

trap term_color_white EXIT
confirmation
install
post

