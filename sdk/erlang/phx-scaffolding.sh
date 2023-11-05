#!/bin/bash

set -e

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
    exit
fi

BASENAME=$(basename $PWD)
DB_PORT="5501"
CONTAINER="phoenix-postgres"

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
        exit 1
    fi

    IS_PHOENIX=$(cat mix.exs | grep :phoenix | wc -l)
    if [[ $IS_PHOENIX == "0" ]]; then
        echo "Not a phoenix project"
        echo "Please run:"
        echo "- mix phx.new $PROJECT_NAME"
        exit 1
    fi
}

modify_endpoint_ip(){
    term_color_red
    echo "Change the endpoint ip to 0.0.0.0"
    term_color_white

    sed -i "s/{127, 0, 0, 1}/{0, 0, 0, 0}/" config/dev.exs
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

reset_docker_container(){
    term_color_red
    echo "Reset the docker container"
    echo "- docker container 'phoenix-postgres' will be reset" 
    echo
    echo "Do you want to proceed? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo 
        return 0
    fi

    # Check if DB is being used by this project
    POSTGRES_EXISTS=$(cat config/dev.exs| grep "postgres" | wc -l)
    if [[ $POSTGRES_EXISTS == "0" ]]; then
        echo 
        echo "No DB is being used - abort"
        echo
        return 0
    fi

    if [[ -f /usr/bin/docker ]]; then
        # If a postgres container is running, remove it.
        if [ $( docker ps -a | grep $CONTAINER | wc -l ) -gt 0 ]; then
            docker container stop $CONTAINER
            docker container rm $CONTAINER
        fi

        docker run \
            --name $CONTAINER \
            --env POSTGRES_USER=postgres \
            --env POSTGRES_PASSWORD=postgres \
            --publish ${DB_PORT}:5432 \
            --detach \
            postgres

        # To access to the DB in container:
        # - docker exec -it ${CONTAINER_NAME} bash"
        # - (from the container) psql -h localhost -U postgres"
        # - (from the psql) CREATE DATABASE ${BASENAME}_dev"
        # - (from the psql) \\l"
    fi
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

    # Find the port number of POSTGRES for development
    # It should be 4 digits. Typically 5501 or 5432.
    PORT_EXISTS=$(cat config/dev.exs| grep "port: \"....\"" | wc -l)
    if [[ $PORT_EXISTS == "0" ]]; then
        # Add 'port: "5501"' right below of localhost
        sed -i "/localhost/a\  port: \"${DB_PORT}\"," config/dev.exs
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

modify_root_component(){
    term_color_red
    echo "Modify:"
    echo "- lib/${BASENAME}_web/components/layouts/root.html.heex"
    term_color_white

    sed -i "s/bg-white/bg-white/" \
        lib/${BASENAME}_web/components/layouts/root.html.heex
}

modify_app_component(){
    term_color_red
    echo "Modify:"
    echo "- lib/${BASENAME}_web/components/layouts/app.html.heex"
    term_color_white

    > lib/${BASENAME}_web/components/layouts/app.html.heex

echo -e \
'<header class="px-4 sm:px-6 lg:px-8">
</header>
<main class="px-4 py-20 sm:px-6 lg:px-8">
  <div class="mx-auto max-w-2xl">
    <.flash_group flash={@flash} />
    <%= @inner_content %>
  </div>
</main>' >> lib/${BASENAME}_web/components/layouts/app.html.heex
}

modify_home_controller(){
    term_color_red
    echo "Modify:"
    echo "- lib/${BASENAME}_web/controllers/page_html/home.html.heex"
    term_color_white

    > lib/${BASENAME}_web/controllers/page_html/home.html.heex

echo -e \
'<.flash_group flash={@flash} />

<div class="text-blue-300 p-10">
    <a href="/dev/dashboard">Dashboard</a>
</div>' >> lib/${BASENAME}_web/controllers/page_html/home.html.heex
}

modify_css(){
    term_color_red
    echo "Modify:"
    echo "- assets/app.css"
    term_color_white

echo -e \
'
html {
    width: 100%;
    height: 100%;
}

body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    /* Hide scrollbars */
    /* overflow: hidden; */
}

app {
    margin: 0;
    padding: 0;
}' >> assets/css/app.css
}

config_gitignore(){
    term_color_red
    echo "Config .gitignore not to commit the heroicons/optimized"
    term_color_white

    echo "/assets/vendor/heroicons/optimized/" >> .gitignore
}

run_phx_gen_auth(){
    term_color_red
    echo "Run 'mix phx.gen.auth Accounts Users user'"
    echo "- mix deps.get & mix ecto.migrate will follow"
    echo
    echo "Do you want to proceed? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo "No auth related codes are installed"
        return
    fi

    mix phx.gen.auth Accounts Users user
    mix deps.get
    mix ecto.migrate
}

post(){
    term_color_red
    echo "Done"
    echo "Try \"mix phx.server --open\""
    term_color_white
}

trap term_color_white EXIT
confirmation
modify_endpoint_ip
install_credo
reset_docker_container
install_ecto
install_tailwind
install_daisyui
install_alpinejs
modify_root_component
modify_app_component
modify_home_controller
modify_css
config_gitignore
run_phx_gen_auth
post
