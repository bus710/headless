#!/bin/bash

set -e

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
    exit
fi

BASENAME=$(basename $PWD)

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo "Phoenix scaffolding:"
    echo "- Credo and ecto will be added"
    echo "- TailwindCSS, DaisyUI, and AlpineJS will be added"
    echo "- Some theme will be cleaned up"
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

    IS_PHOENIX=$(cat mix.exs | grep :phoenix | wc -l)
    if [[ $IS_PHOENIX == "0" ]]; then
        echo "Not a phoenix project"
        echo "Please run:"
        echo "- mix phx.new $PROJECT_NAME"
        exit -1
    fi
}

install_credo(){
    term_color_red
    echo "Install credo"
    term_color_white

    # Add credo after phoenix in the dependencies.
    CREDO_EXISTS=$(cat mix.exs | grep credo | wc -l)
    if [[ $CREDO_EXISTS == "0" ]]; then
        # (The output of below might be {:credo,"~> 1.7"},)
        CREDO_VERSION=$(mix hex.info credo | grep Config | awk '{print $2 " " $3 " " $4 ","}')
        # Add!
        sed -i "/:phoenix,/a\ \t${CREDO_VERSION}" mix.exs
    fi
    mix deps.get
    mix credo gen.config
}

install_ecto(){
    # Check if this project uses ecto at all
    ECTO_EXISTS=$(cat mix.exs| grep ":phoenix_ecto"| wc -l)
    if [[ $ECTO_EXISTS == "0" ]]; then
        return
    fi

    term_color_red
    echo "Install ecto"
    term_color_white

    # Find the port number of POSTGRESQL for development
    # It should be 4 digits. Typically 5501 or 5432.
    PORT_EXISTS=$(cat config/dev.exs| grep "port: \"....\"" | wc -l)
    if [[ $PORT_EXISTS == "0" ]]; then
        sed -i "/localhost/a\ port: \"5501\"," config/dev.exs
    fi

    mix ecto.create
    mix ecto.migrate
}

install_tailwind(){
    term_color_red
    echo "Install tailwind"
    term_color_white

    mix tailwind.install
}

install_daisyui(){
    term_color_red
    echo "Install daisyui"
    term_color_white

    cd assets

    npm i -D daisyui@latest
    sed -i "/require(\"\@tailwindcss\/forms\"),/a\ require(\"daisyui\")," tailwind.config.js

    cd ..
}

install_alpinejs(){
    term_color_red
    echo "Install alphinejs"
    term_color_white

    cd assets
    npm i alpinejs

    sed -i "/let csrfToken/c\ " js/app.js
    sed -i "/let liveSocket/c\ " js/app.js

    sed -i "/vendor\/topbar\"/a\ "\
'import Alpine from "alpinejs" \n'\
'window.Alpine = Alpine; \n'\
'Alpine.start(); \n'\
'let hooks = {}; \n'\
'let csrfToken = document.querySelector("meta[name=$CSRF_TOKEN]").getAttribute("content") \n'\
'let liveSocket = new LiveSocket("/live", Socket, { \n'\
'  params: { _csrf_token: csrfToken }, \n'\
'  hooks: hooks, \n'\
'  dom: { \n'\
'    onBeforeElUpdated(from, to) { \n'\
'      if (from._x_dataStack) { \n'\
'        window.Alpine.clone(from, to); \n'\
'      } \n'\
'    }, \n'\
'  }, \n'\
'}); \n' js/app.js

    sed -i "s/\$CSRF_TOKEN/'csrf-token'/" js/app.js

    cd ..
}

cleanup_theme(){
    term_color_red
    echo "Cleanup theme in those files:"
    term_color_white
    echo "- lib/${BASENAME}_web/components/layouts/root.html.heex"
    echo "- lib/${BASENAME}_web/components/layouts/app.html.heex"
    echo "- lib/${BASENAME}_web/controllers/page_html/home.html.heex"
 
    > lib/${BASENAME}_web/components/layouts/root.html.heex
    > lib/${BASENAME}_web/components/layouts/app.html.heex
    > lib/${BASENAME}_web/controllers/page_html/home.html.heex

echo -e \
'<!DOCTYPE html>
<html lang="en" class="[scrollbar-gutter:stable]">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content={get_csrf_token()} />
    <.live_title suffix=" · Phoenix Framework">
      <%= assigns[:page_title] || "Demo" %>
    </.live_title>
    <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
    <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
    </script>
  </head>
  <body class="bg-white antialiased">
    <%= @inner_content %>
  </body>
</html>
' >> lib/${BASENAME}_web/components/layouts/root.html.heex

echo -e \
'<header class="px-4 sm:px-6 lg:px-8">
</header>
<main class="px-4 py-20 sm:px-6 lg:px-8">
  <div class="mx-auto max-w-2xl">
    <.flash_group flash={@flash} />
    <%= @inner_content %>
  </div>
</main>' >> lib/${BASENAME}_web/components/layouts/app.html.heex

echo -e \
'<.flash_group flash={@flash} />' >> lib/${BASENAME}_web/controllers/page_html/home.html.heex
}

config_gitignore(){
    term_color_red
    echo "Config .gitignore not to commit the heroicons/optimized"
    term_color_white

    echo "/assets/vendor/heroicons/optimized/" >> .gitignore
}

post(){
    term_color_red
    echo "Done"
    echo "Try \"mix phx.server --open\""
    term_color_white
}

trap term_color_white EXIT
confirmation
install_credo
install_ecto
install_tailwind
install_daisyui
install_alpinejs
cleanup_theme
config_gitignore
post
