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

    IS_REACT=$(cat package.json | grep react | wc -l)
    if [[ $IS_REACT == "0" ]]; then
        echo "Not a react project"
        echo "Please run:"
        echo "- create vite@latest $APP_NAME -- --template react"
        exit -1
    fi
}

install_packages(){
    term_color_red
    echo "Install packages"
    term_color_white

    npm install -D \
        tailwindcss \
        postcss \
        autoprefixer \
        flowbite \
        flowbite-react

    npm install -D \
        prettier \
        eslint

    npx tailwindcss init -p
}

configure_template_paths(){
    term_color_red
    echo "Configure template paths"
    term_color_white

    #sed -i 's/content: \[\],/content: \[".\/index.html", ".\/src\/**\/*{js,tx,jsx,tsx}"\],/' tailwind.config.js
    > tailwind.config.js

    echo -e \
"/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './index.html', './src/**/*{js,tx,jsx,tsx}',
    'node_modules/flowbite-react/**/*.{js,jsx,ts,tsx}'
  ],
  theme: {
    extend: {
      colors: {
        primary: { 50: '#ebf5ff', 100: '#fff1ee', 200: '#ffe4de', 300: '#ffd5cc', 400: '#ffbcad', 500: '#fe795d', 600: '#ef562f', 700: '#eb4f27', 800: '#d3330a', 900: '#d3330a' },
      },
    },
  },
  plugins: [
    require('flowbite/plugin')
  ],
}" >> tailwind.config.js

}

add_tailwind_directives(){
    term_color_red
    echo "Add tailwind directives"
    term_color_white

    if [[ -f ./src/index.css ]]; then
        > ./src/index.css
        echo "@tailwind base;" >> ./src/index.css
        echo "@tailwind components;" >> ./src/index.css
        echo "@tailwind utilities;" >> ./src/index.css
    else
        echo "No index.css is found."
    fi
}

update_app_jsx(){
    term_color_red
    echo "Update App.jsx"
    term_color_white

    if [[ -f ./src/App.jsx ]]; then
        > ./src/App.jsx
        echo -e \
        "import './App.css'
import { Button } from 'flowbite-react';

function App() {
  return (
    <h1 className=\"text-3xl font-bold items-center\">
      Hello world!
      <Button>Click me</Button>
    </h1>
  )
}

export default App;
" >> ./src/App.jsx 
    else
        echo "No App.jsx is found"
    fi
}

update_app_css(){
    term_color_red
    echo "Remove App.css"
    term_color_white

    > ./src/App.css

echo -e \
    "#root {
  max-width: 1280px;
  margin: 0 auto;
  padding: 2rem;
  text-align: center;
}" >> ./src/App.css
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
update_app_jsx
update_app_css
post
