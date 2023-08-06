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
    echo "Phoenix scaffolding:"
    echo "- TailwindCSS and AlpineJS will be added."
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
    term_color_red
    echo "Install ecto"
    term_color_white

    # Find the port number of POSTGRESQL for development
    # It should be 4 digits. Typically 5501 or 5432.
    PORT_EXISTS=$(cat config/dev.exs| grep "port: \"....\"" | wc -l)
    if [[ $PORT_EXISTS == "0" ]]; then
        sed -i "/localhost/a\ port: \"5501\"," config/dev.exs

        mix ecto.create
        mix ecto.migrate
    fi

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
post
