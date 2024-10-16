#!/bin/bash

set -e

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
    exit
fi

BASENAME=$(basename $PWD)
CAP_BASENAME="${BASENAME^}"

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){

    term_color_red
    echo "Elixir scaffolding:"
    echo "- The mix.exs and /lib/${BASENAME}.ex will be updated"
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

    # Check if this is a typical mix based project made by [mix new].
    IS_MIXPROJ=$(grep MixProject < mix.exs | wc -l)
    if [[ $IS_MIXPROJ == "0" ]]; then
        echo "Not a mix based project"
        echo "Please run:"
        echo "- mix new $PROJECT_NAME"
        exit 1
    fi

    term_color_red
    echo "Get the basic libraries"
    term_color_white

    mix deps.get
}

install_module_entry(){
    term_color_red
    echo "Install a module entry in the mix.exs"
    term_color_white

    # Add ${CAP_BASENAME} mod in the application function if not exist
    MOD_EXISTS=$(grep "mod: {$CAP_BASENAME" < mix.exs | wc -l)
    if [[ $MOD_EXISTS == "0" ]]; then
        # Add after 2 lines after matching (with 6 spaces and a new line)
        sed -i "/def application do/{N;N;a\ \ \ \ \ \ mod: {${CAP_BASENAME}, []},
        }" mix.exs
    fi
}

install_module_function(){
    term_color_red
    echo "Install a module function in the ${BASENAME}.ex"
    term_color_white

    # Remove the last line (it should be 'end')
    sed -i '$ d' lib/${BASENAME}.ex

    echo "
  use Application

  def start(_type, _args) do
    IO.puts \"1\"
    IO.puts \"2\"
    IO.puts \"3\"
    {:ok, self()}
  end
end" >> ./lib/${BASENAME}.ex
}

install_extra_apps(){
    term_color_red
    echo "Install extra applications such as eex, wx, runtime_tools, debugger, observer"
    term_color_white

    sed -i '/extra_applications\: /c\ \ \ \ \ \ extra_applications: [:logger, :eex, :wx, :runtime_tools, :debugger, :observer],' mix.exs
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

install_vscode_launch_json(){
    term_color_red
    echo "Install vscode launch json for debugging"
    term_color_white

    rm -rf ./.vscode
    cp -r ~/repo/headless/sdk/otp/vscode ./.vscode
}

config_gitignore(){
    term_color_red
    echo "Config .gitignore"
    term_color_white

    echo ".elixir-tools" >> .gitignore
    echo ".elixir_ls" >> .gitignore
    echo ".vscode" >> .gitignore
}

post(){
    term_color_red
    echo "Done"
    echo "- Try \"mix run\""
    echo "- Or \"iex -S mix\" and \"${CAP_BASENAME}.start(1,2)\" or \":debugger.start()\""
    term_color_white
}

trap term_color_white EXIT
confirmation
install_module_entry
install_module_function
install_extra_apps
install_credo
config_gitignore
post

