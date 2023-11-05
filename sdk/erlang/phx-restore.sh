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

run-mix-setup(){
    term_color_red
    echo "run mix setup"
    term_color_white

    mix setup
}

post(){
    term_color_red
    echo "Done"
    echo "- mix phx.server --open"
    echo "- docker run --name phoenix-postgres \\"
    echo "    --env POSTGRES_USER=postgres \\"
    echo "    --env POSTGRES_PASSWORD=postgres \\"
    echo "    --port 5501:5432 \\"
    echo "    --detach \\"
    echo "    ${BASENAME}_dev"
    term_color_white
}

trap term_color_white EXIT
confirmation
restore-heroicons
restore-npm
run-mix-setup
post
