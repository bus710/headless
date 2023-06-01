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
    echo "TailwindCSS will be added."
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

    IS_SVELTE=$(cat package.json | grep svelte | wc -l)
    if [[ $IS_REACT == "0" ]]; then
        echo "Not a svelte project"
        echo "Please run:"
        echo "- create vite@latest $APP_NAME -- --template svelte"
        exit -1
    fi
}

install_packages(){
    term_color_red
    echo "Install packages"
    term_color_white

    npm install -D tailwindcss postcss autoprefixer tinro
    npx tailwindcss init tailwind.config.cjs -p
}

configure_template_paths(){
    term_color_red
    echo "Configure template paths"
    term_color_white

    sed -i 's/content: \[\],/content: \[".\/src\/**\/*{html,js,svelte,ts}"\],/' tailwind.config.cjs
}

add_tailwind_directives(){
    term_color_red
    echo "Add tailwind directives"
    term_color_white

    if [[ -f ./src/app.css ]]; then
        > ./src/app.css
        echo "@tailwind base;" >> ./src/app.css
        echo "@tailwind components;" >> ./src/app.css
        echo "@tailwind utilities;" >> ./src/app.css
    else
        echo "No app.css is found."
    fi
}

update_app_svelte(){
    term_color_red
    echo "Update App.svelte"
    term_color_white

    if [[ -f ./src/App.svelte ]]; then
        > ./src/App.svelte
        echo -e \
            "<h1 class='text-3xl font-bold underline'>Hello!</h1>" >> \
            ./src/App.svelte
    else
        echo "No App.svelte is found"
    fi
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
configure_template_paths
add_tailwind_directives
update_app_svelte
post
