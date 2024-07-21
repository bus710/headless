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
    echo "Check if there is a package.json"
    term_color_white

    if [[ ! -f package.json ]]; then
        echo "Not found"
        exit 1
    fi

    echo "Found it"
    echo
}

# not_available(){
#     term_color_red
#     echo "SvelteKit scaffolding with:"
#     echo "- Javascript"
#     echo "- TailwindCSS"
#     echo "- TailwindCSS Forms plugin"
#     echo "- TailwindCSS Typography plugin"
#     echo "- TailwindCSS DaisyUI"
#     echo "- Autoprefixer & PostCSS"
#     echo "- ESLint & Playwright & Prettier"
#     echo "- No example code"
#     echo
#     echo "Do you want to proceed? (y/n)"
#     term_color_white
#
#     echo
#     read -n 1 ans
#     echo
#
#     if [[ ! $ans == "y" ]]; then
#         echo ""
#         exit 1
#     fi
#
#     term_color_red
#     echo "Project name?"
#     term_color_white
#
#     echo
#     read PROJECT_NAME
#     echo
#
#     LEN=$(echo $PROJECT_NAME | wc -l)
#
#     if [[ $LEN == "0" ]]; then
#         echo "Not a proper project name"
#         exit 1
#     fi
#
#     # Need to remove the newline at the end of the string
#     PROJECT_NAME2=$(echo $PROJECT_NAME | tr -d '\r')
#
#     npm create @svelte-add/kit@latest $PROJECT_NAME2 -- \
#         --with javescript+eslint+playwright+prettier+postcss+autoprefixer+tailwindcss \
#         --tailwindcss-forms \
#         --tailwindcss-typography \
#         --tailwindcss-daisyui
## $ npm install -D \
#     autoprefixer \
#     tailwindcss \
#     postcss \
#     tinro
# $ npx tailwindcss init tailwind.config.cjs -p
# }

install_packages(){
    term_color_red
    echo "Install packages"
    term_color_white

    cd "$PROJECT_NAME"

    npm install -D \
        classnames \
        @popperjs/core \
        @formkit/auto-animate \
        svelte-hero-icons \
        daisyui \
        @tailwindcss/forms

    # npx tailwindcss init tailwind.config.cjs -p
}

configure_tailwind(){
    term_color_red
    echo "Config tailwind"
    term_color_white

echo "" > tailwind.config.js
echo "
/** @type {import('tailwindcss').Config} */
export default {
	content: ['./src/**/*.{html,js,svelte,ts}'],

	theme: {
		extend: {}
	},

	plugins: [
		require('@tailwindcss/typography'),
		require('@tailwindcss/forms'),
		require('daisyui'),
	]
};" >> tailwind.config.js

}

post(){
    term_color_red
    echo "Done"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_packages
configure_tailwind
post

