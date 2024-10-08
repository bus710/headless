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
        jq '.scripts.build = "tsc"' |
        jq '.scripts.lint = "eslint"' |
        jq '.scripts.format = "prettier --ignore-path .gitignore --write \"**/*.+(js|ts|json)\""'> package.tmp
    cat package.tmp > package.json && rm -rf package.tmp

    # Also add packages for restoring
    npm i --save-dev typescript
    npm i --save-dev eslint \
        @typescript-eslint/parser \
        @typescript-eslint/eslint-plugin \
        eslint-config-prettier \
        prettier

    # Add the main.ts file
    mkdir src
    echo 'console.log("hello");' > src/main.ts

    touch .gitignore
    echo 'package-lock.json' >> .gitignore
    echo 'node_modules' >> .gitignore
    echo 'dist' >> .gitignore

    term_color_red
    echo 'Some questions will be asked'
    echo '- ✔ How would you like to use ESLint? · problems'
    echo '- ✔ What type of modules does your project use? · javascript module'
    echo '- ✔ Which framework does your project use? · none of those'
    echo '- ✔ Does your project use TypeScript? · yes, typescript'
    echo '- ✔ Where does your code run? · node (use the space key to toggle)'
    echo '- ✔ Would you like to install them now? · Yes'
    echo '- ✔ Which package manager do you want to use? · npm'
    term_color_white

    npx eslint --init
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

