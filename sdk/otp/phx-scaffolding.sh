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
    CONTAINER_NAME=${CONTAINER}_${BASENAME}

    term_color_red
    echo "Phoenix scaffolding:"
    echo "- Liveview based auth will be added (gen auth)"
    echo "- Credo, Ecto, DaisyUI and LiveSvelte will be added"
    echo "- The container name will be $CONTAINER_NAME"
    echo
    echo "Do you want to proceed? (Y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ $ans == "n" ]]; then
        echo ""
        exit 1
    fi

    # Check if this is a typical phoenix project made by [mix phx.new].
    IS_PHOENIX=$(grep :phoenix < mix.exs | wc -l)
    if [[ $IS_PHOENIX == "0" ]]; then
        echo "Not a phoenix project"
        echo "Please run:"
        echo "- mix phx.new $PROJECT_NAME"
        exit 1
    fi

    # Check if there is an existing container that has the same name.
    # If exists, it should be reset or this script should quit
    CONTAINER_EXISTS=$(docker container ls --format '{"name":"{{.Names}}"}' | \
        jq '.name' | jq -s | \
        jq --arg CONTAINER_NAME "$CONTAINER_NAME" 'any(. == $CONTAINER_NAME)')

    if [[ $CONTAINER_EXISTS == "true" ]]; then
        term_color_red
        echo "There is a docker container that has the same name as this project - $CONTAINER_NAME"
        term_color_white

        echo "Please review below:"
        docker container ls --format '{"name":"{{.Names}}"}' | jq '.name' 
        echo

        term_color_red
        echo "Abort."
        echo "Please use another project name or remove the container with [docker container stop \$CONTAINER_NAME]"
        term_color_white

        exit 1
    fi

    term_color_red
    echo "Get the basic libraries"
    term_color_white

    mix deps.get
}

modify_endpoint_ip(){
    term_color_red
    echo "Change the endpoint ip to 0.0.0.0 to open to public"
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
    echo "The DB port is 5501 - change? (y/N)"
    echo "Check with [ss -tulnp]"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ $ans == "y" ]]; then
        echo "Please specify 4 digits number:"
        read -n 4 port 

        if [[ ! $port == "" ]]; then
            DB_PORT=$port
        fi

        echo 
        echo "The given port is $DB_PORT"
        echo 
    fi
}

launch_postgresql_docker_container(){
    term_color_red
    echo "Launch the docker container"
    echo "- docker container ${CONTAINER}_${BASENAME}:$DB_PORT will be launched" 
    term_color_white

    # Check if DB is being used by this project
    POSTGRES_EXISTS=$(grep "postgres" < config/dev.exs | wc -l)
    if [[ $POSTGRES_EXISTS == "0" ]]; then
        echo 
        echo "No DB is specified in the config/dev.exs - abort"
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

run_phx_gen_auth(){
    term_color_red
    echo "Run 'mix phx.gen.auth Accounts Users user'"
    echo "- mix deps.get & mix ecto.migrate will follow"
    echo
    echo "Do you want to proceed? (Y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ $ans == "n" ]]; then
        echo "No auth related codes are installed"
        return
    fi

    mix phx.gen.auth Accounts Users user
    mix deps.get
    mix ecto.migrate
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

install_live_svelte_example(){
    term_color_red
    echo "Install live_svelte examples"
    term_color_white

    # If there is the live_svelte in the deps, add a set of example liveview and svelte files
    
    SVELTE_EXISTS=$(grep live_svelte < mix.exs | wc -l)
    if [[ ! $SVELTE_EXISTS == "0" ]]; then
        mkdir ./lib/${BASENAME}_web/live2
        cat /home/$LOGNAME/repo/headless/sdk/otp/99_live_svelte_example.ex >> ./lib/${BASENAME}_web/live2/example.ex
        CAP_BASENAME="${BASENAME^}"
        sed -i "s/{APP_NAME}/${CAP_BASENAME}/g" ./lib/${BASENAME}_web/live2/example.ex

        cat /home/$LOGNAME/repo/headless/sdk/otp/99_live_svelte_example.svelte >> ./assets/svelte/Example.svelte

        # Add a new line and commented route for reference
        echo "" >> ./lib/${BASENAME}_web/router.ex
        echo '# live "/example", Example' >> ./lib/${BASENAME}_web/router.ex

        echo "- update /lib/${BASENAME}_web/router.ex"
        echo "- check /lib/${BASENAME}_web/live2/example.ex"
        echo "- check /assets/svelte/Example.svelte"
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

config_gitignore(){
    term_color_red
    echo "Config .gitignore not to commit the heroicons/optimized"
    term_color_white

    echo "/assets/vendor/heroicons/optimized/" >> .gitignore
    echo ".elixir-tools" >> .gitignore
    echo "/assets/svelte/_build" >> .gitignore
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
launch_postgresql_docker_container
install_ecto
run_phx_gen_auth
install_daisyui
install_live_svelte_lib
install_live_svelte_example
install_credo
config_gitignore
post


## No need to run below functions
# install_alpinejs
# modify_app_component    # If want to cleanup
# modify_home_controller  # If want to cleanup
# modify_css              # If want to cleanup

install_tailwind(){
    term_color_red
    echo "Install tailwind"
    term_color_white

    mix tailwind.install
}

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
