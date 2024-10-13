#!/bin/bash

set -e

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
    exit
fi

BASENAME=$(basename $PWD)
CONTAINER="phoenix_postgres"
# DB_PORT=$(grep 'port: \"....\"' < config/dev.exs | cut -d'"' -f 2)
DB_PORT="5501"

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo "Phoenix scaffolding:"
    echo "- Credo, Ecto, DaisyUI and LiveSvelte will be added"
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

    IS_PHOENIX=$(grep :phoenix < mix.exs | wc -l)
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

config_http_port(){
    term_color_red
    echo "Config the http port to 4002"
    echo "- Check with netstat -tuln or ss -tuln"
    echo
    term_color_white

    sed -i "s/port: 4000/port: 4002/" config/dev.exs
}

config_db_port(){
    term_color_red
    echo "Config the DB port to 5501 or something else"
    echo "- Check with netstat -tuln or ss -tuln"
    echo "- Docker Postgresql container might be using the 5501 port, then don't change"
    echo
    echo "The default port is 5501 - change? (y/N)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ $ans == "y" ]]; then
        echo "Please put 4 digits numbers"
        read -n 4 port 

        if [[ ! $port == "" ]]; then
            DB_PORT=$port
        fi

        echo 
        echo "The given port is $DB_PORT"
        echo 
    fi
}

install_credo(){
    term_color_red
    echo "Install credo"
    term_color_white

    # Add credo after phoenix in the dependencies.
    CREDO_EXISTS=$(grep credo < mix.exs | wc -l)
    if [[ $CREDO_EXISTS == "0" ]]; then
        # (The output of below might be {:credo,"~> 1.7"},)
        CREDO_VERSION=$(mix hex.info credo | grep Config | awk '{print $2 " " $3 " " $4 ","}')
        # Add after 3 lines after matching (with 6 spaces and a new line)
        sed -i "/defp deps do/{N;N;N;a\ \ \ \ \ \ ${CREDO_VERSION}
        }" mix.exs
    fi
    mix deps.get
    mix credo gen.config
}

install_live_svelte_lib(){
    term_color_red
    echo "Install live_svelte library"
    term_color_white

    # Add live_svelte after phoenix in the dependencies.
    SVELTE_EXISTS=$(grep live_svelte < mix.exs | wc -l)
    if [[ $SVELTE_EXISTS == "0" ]]; then

        # 1. Update the deps list for the live_svelte library in the mix.exs
        # - The output of below might be {:live_svelte,"~> 0.14.0"},
        # - Add the info with 6 spaces and a new line after 3 lines after matching 
        SVELTE_VERSION=$(mix hex.info live_svelte | grep Config | awk '{print $2 " " $3 " " $4 ","}')
        sed -i "/defp deps do/{N;N;N;a\ \ \ \ \ \ ${SVELTE_VERSION}
        }" mix.exs

        # 2. Update the aliases list for the setup process in the mix.exs
        # - Replace the setup line with the given string
        # - Replace the esbuild line with the given string
        sed -i '/setup\: /c\ \ \ \ \ \ setup: ["deps.get", "ecto.setup", "npm install --prefix assets"],' mix.exs
        sed -i '/"esbuild .* --minify"/c\ \ \ \ \ \ \ "node build.js --deploy --prefix assets",' mix.exs

        # 3. Get dependencies and run the setup process 
        mix deps.get
        mix live_svelte.setup

        # 4. Update /lib/${APP}_web.ex for the html_helpers
        # - Add a comment and import lines in the html_helpers function
        HTML_HELPER="./lib/${BASENAME}_web.ex"
        sed -i "/defp html_helpers do/{N;N;N;N;N;N;a\ \ \ \ \ \ import LiveSvelte
        }" $HTML_HELPER
        sed -i "/defp html_helpers do/{N;N;N;N;N;N;a\ \ \ \ \ \ # Svelte helper
        }" $HTML_HELPER

        # 5. Update the /assets/tailwind.config.js to get TW support
        # - Add the svelte config
        TW_CONFIG="./assets/tailwind.config.js"
        sed -i "/content: /a\ \ \ \ \"./svelte/**/*.svelte\"," $TW_CONFIG

        # 6. Update the /config/config.exs to remove the esbuild config
        # - Delete the esbuild block - 9 lines
        CONFIG_EXS="./config/config.exs"
        sed -i "/Configure esbuild/{N;N;N;N;N;N;N;N;N;d}" $CONFIG_EXS
    fi
}

reset_docker_container(){
    term_color_red
    echo "Reset the docker container"
    echo "- docker container ${CONTAINER}_${BASENAME} will be reset" 
    echo
    echo "Do you want to proceed? (y/n)"
    term_color_white

    docker container ls

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo 
        return 0
    fi

    # Check if DB is being used by this project
    POSTGRES_EXISTS=$(grep "postgres" < config/dev.exs | wc -l)
    if [[ $POSTGRES_EXISTS == "0" ]]; then
        echo 
        echo "No DB is being used - abort"
        echo
        return 0
    fi

    if [[ -f /usr/bin/docker ]]; then
        # If a postgres container is running, remove it.
        if [ $( docker ps -a | grep ${CONTAINER}_${BASENAME} | wc -l ) -gt 0 ]; then
            docker container stop ${CONTAINER}_${BASENAME}
            docker container rm ${CONTAINER}_${BASENAME}
        fi

        docker run \
            --name ${CONTAINER}_${BASENAME} \
            --env POSTGRES_USER=postgres \
            --env POSTGRES_PASSWORD=postgres \
            --publish ${DB_PORT}:5432 \
            --detach \
            postgres

        # To access to the DB in container:
        # - docker exec -it ${CONTAINER}_${BASENAME} bash"
        # - (from the container) psql -h localhost -U postgres"
        # - (from the psql) CREATE DATABASE ${BASENAME}_dev"
        # - (from the psql) \\l"
        # - (to exit from psql)
        # - (to exit from docker) ^p^q
    fi
}

install_ecto(){
    # Check if this project uses ecto at all
    ECTO_EXISTS=$(grep ":phoenix_ecto" < mix.exs | wc -l)
    if [[ $ECTO_EXISTS == "0" ]]; then
        return
    fi

    term_color_red
    echo "Install ecto"
    term_color_white

    # Find the port number of POSTGRES for development
    # It should be 4 digits. Typically 5501 or 5432.
    PORT_EXISTS=$(grep "port: \"....\"" < config/dev.exs | wc -l)
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

config_gitignore(){
    term_color_red
    echo "Config .gitignore not to commit the heroicons/optimized"
    term_color_white

    echo "/assets/vendor/heroicons/optimized/" >> .gitignore
    echo ".elixir-tools" >> .gitignore
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

install_live_svelte_example(){
    term_color_red
    echo "Install live_svelte example"
    echo "- Add [live \"/example\", Example] in the router.ex"
    term_color_white

    # If there is live_svelte, add a set of example liveview and svelte files
    # - Add a liveview under the /lib/${APP}_web/live2 directory
    # - Add a svelte file under the /assets/

    SVELTE_EXISTS=$(grep live_svelte < mix.exs | wc -l)
    if [[ ! $SVELTE_EXISTS == "0" ]]; then
        mkdir ./lib/${BASENAME}_web/live2
        cat /home/$LOGNAME/repo/headless/sdk/otp/99_live_svelte_example.ex >> ./lib/${BASENAME}_web/live2/example.ex
        CAP_BASENAME="${BASENAME^}"
        sed -i "s/{APP_NAME}/${CAP_BASENAME}/g" ./lib/${BASENAME}_web/live2/example.ex

        cat /home/$LOGNAME/repo/headless/sdk/otp/99_live_svelte_example.svelte >> ./assets/svelte/Example.svelte
    fi
}

post(){
    term_color_red
    echo "Done"
    echo "Try \"mix phx.server --open\""
    echo "Or  \"iex -S mix phx.server\" (for better interactivity)"
    term_color_white
}

trap term_color_white EXIT
confirmation
modify_endpoint_ip
config_http_port
config_db_port
install_credo
install_live_svelte_lib
reset_docker_container
install_ecto
install_daisyui
config_gitignore
run_phx_gen_auth
install_live_svelte_example
post


## No need to run below functions
# install_alpinejs
# modify_app_component    # If want to cleanup
# modify_home_controller  # If want to cleanup
# modify_css              # If want to cleanup

install_alpinejs(){
    term_color_red
    echo "Install alphinejs"
    term_color_white

    cd assets
    npm i alpinejs
    > js/app.js
    cat /home/$LOGNAME/repo/headless/sdk/otp/99_app.js >> js/app.js
    cd ..
}

modify_app_component(){
    term_color_red
    echo "Modify:"
    echo "- lib/${BASENAME}_web/components/layouts/app.html.heex"
    term_color_white

    > lib/${BASENAME}_web/components/layouts/app.html.heex
    cat /home/$LOGNAME/repo/headless/sdk/otp/99_app.html.heex >> lib/${BASENAME}_web/components/layouts/app.html.heex
}

modify_home_controller(){
    term_color_red
    echo "Modify:"
    echo "- lib/${BASENAME}_web/controllers/page_html/home.html.heex"
    term_color_white

    > lib/${BASENAME}_web/controllers/page_html/home.html.heex
    cat /home/$LOGNAME/repo/headless/sdk/otp/99_home.html.heex >> lib/${BASENAME}_web/controllers/page_html/home.html.heex
}

modify_css(){
    term_color_red
    echo "Modify:"
    echo "- assets/app.css"
    term_color_white

    cd assets
    > css/app.css
    cat /home/$LOGNAME/repo/headless/sdk/otp/99_app.css >> css/app.css
    cd ..
}
