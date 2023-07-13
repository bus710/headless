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
    echo "SvelteKit scaffolding with:"
    echo "- Javascript"
    echo "- TailwindCSS"
    echo "- TailwindCSS Forms plugin"
    echo "- TailwindCSS Typography plugin"
    echo "- TailwindCSS DaisyUI"
    echo "- Autoprefixer & PostCSS"
    echo "- ESLint & Playwright & Prettier"
    echo "- No example code"
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

    term_color_red
    echo "Project name?"
    term_color_white

    echo
    #read -r PROJECT_NAME
    while IFS=$' \t\r\n' read -r PROJECT_NAME 
    echo

    LEN=$(echo $PROJECT_NAME | wc -l)

    if [[ $LEN == "0" ]]; then
        echo "Not a proper project name"
        exit -1
    fi

    npm create @svelte-add/kit@latest $PROJECT_NAME -- --with javescript+eslint+playwright+prettier+postcss+autoprefixer+tailwindcss --tailwindcss-forms --tailwindcss-typography --tailwindcss-daisyui
}

install_packages(){
    term_color_red
    echo "Install packages"
    term_color_white

    npm install -D \
        classnames \
        @popperjs/core \
        @formkit/auto-animate

    #npx tailwindcss init tailwind.config.cjs -p
}

post(){
    term_color_red
    echo "Done"
    echo "Try \"npm run dev -- --open\""
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
post

