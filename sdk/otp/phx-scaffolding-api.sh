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
    echo "Phoenix scaffolding for API server:"
    echo "- Make sure the project created with 'mix phx.new api --no-html --no-assets --no-live --no-gettext --no-mailer'"
    echo "- Credo and ecto will be added"
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
        # Add!
        sed -i "/:phoenix,/a\ \t${CREDO_VERSION}" mix.exs
    fi
    mix deps.get
    mix credo gen.config
}

reset_docker_container(){
    term_color_red
    echo "Reset the docker container"
    echo "- docker container ${CONTAINER}_${BASENAME} will be reset" 
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

config_gitignore(){
    term_color_red
    echo "Config .gitignore not to commit the heroicons/optimized"
    term_color_white

    echo "/assets/vendor/heroicons/optimized/" >> .gitignore
    echo ".elixir-tools" >> .gitignore
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
reset_docker_container
install_ecto
config_gitignore
post
