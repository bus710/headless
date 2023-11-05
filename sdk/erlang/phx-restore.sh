#!/bin/bash

set -e

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
    exit
fi

BASENAME=$(basename $PWD)
CONTAINER="phoenix-postgres"
DB_PORT="5501"

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo "Phoenix restore does:"
    echo "- restore Heroicons"
    echo "- restore npm install"
    echo "- run mix setup"
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

restore-heroicons(){
    term_color_red
    echo "restore heroicons"
    term_color_white

    cd assets/vendor/heroicons
    sed -n 4,10p UPGRADE.md | bash -
    cd -
}

restore-npm(){
    term_color_red
    echo "restore npm packages"
    term_color_white

    cd assets
    npm i
    cd -
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
        echo "DB is not being used - abort"
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
        # - (to exit from psql)
        # - (to exit from docker) ^p^q
    fi
}

run-mix-setup(){
    term_color_red
    echo "run mix setup"
    term_color_white

    mix setup
}

post(){
    term_color_red
    echo "Do these commands"
    echo "- mix ecto.migrate"
    echo "- mix phx.server --open"
    term_color_white
}

trap term_color_white EXIT
confirmation
restore-heroicons
restore-npm
reset_docker_container
run-mix-setup
post
