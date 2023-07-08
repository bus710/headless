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
    echo "Svelte scaffolding:"
    echo "- TailwindCSS will be added."
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
    if [[ $IS_SVELTE == "0" ]]; then
        echo "Not a svelte project"
        echo "Please run:"
        echo "- npm create vite@latest $APP_NAME -- --template svelte"
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
        tinro \
        flowbite \
        flowbite-svelte \
        classnames \
        @popperjs/core \
        @formkit/auto-animate

    npm install -D \
        prettier \
        eslint

    npx tailwindcss init tailwind.config.cjs -p
}

configure_vite(){
    term_color_red
    echo "Configure vite"
    term_color_white

    # Add 'import path from "path";' in the beginnig
    sed -i '1 i\import path from \"path\";' vite.config.js
    # Add these lines after "plugins:"
    # resolve: {
    #  alias: {
    #   $lib: path.resolve("./src/lib"),
    #   $comp: path.resolve("./src/components"),
    #  },
    # },
    sed -i '/plugins:/a \'\
'resolve: {\n'\
'alias: {\n'\
'$lib: path.resolve(\"./src/lib\"),\n'\
'$comp: path.resolve(\"./src/components\"),\n'\
'},\n'\
'},' vite.config.js
}

configure_template_paths(){
    term_color_red
    echo "Configure template paths"
    term_color_white

    # sed -i 's/content: \[\],/content: \[".\/src\/**\/*{html,js,svelte,ts}"\],/' tailwind.config.cjs
    > tailwind.config.cjs

    echo -e \
"/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './src/**/*{html,js,svelte,ts}',
    './node_modules/flowbite-svelte/**/*.{html,js,svelte,ts}',
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

  darkmode: 'class',
}" >> ./tailwind.config.cjs

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

update_index_html(){
    term_color_red
    echo "Update index.html for dark mode"
    term_color_white

    > index.html

    echo -e '<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SenseHAT x Tauri</title>
    <script>
      if (
        localStorage.theme === "dark" ||
        (!("theme" in localStorage) &&
          window.matchMedia("(prefers-color-scheme: dark)").matches)
      ) {
        document.documentElement.classList.add("dark");
      } else {
        document.documentElement.classList.remove("dark");
      }
    </script>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.js"></script>
  </body>
</html>' > index.html
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
configure_vite
configure_template_paths
add_tailwind_directives
update_app_svelte
update_index_html
post

# Add darkmode in index.html
