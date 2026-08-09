#!/bin/bash

# Post-install tooling for the language SDKs (node, python, go, rust).
# Run this AFTER the language cores (30..34) and BEFORE nvim (50/51), since
# nvim/AstroNvim wires up the LSPs, formatters and DAP adapters installed here.
#
# Each language is its own section. Sections are wrapped so that one
# language's failure does not abort the rest; a summary is printed at the end.

set -e

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
    exit
fi

PYTHON_VERSION="3.12"
FAILED=()

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

setup_env(){
    # The cores install into standard locations wired up by .shrc, but this
    # script may run in a shell that predates those edits, so make each SDK
    # visible here explicitly.

    # uv (python)
    export PATH="$HOME/.local/bin:$PATH"

    # cargo (rust)
    [ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"
    export PATH="$HOME/.cargo/bin:$PATH"

    # go
    export GOROOT=/usr/local/go
    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    export PATH="$GOROOT/bin:$GOBIN:$PATH"

    # nvm / node
    if [[ -d "$HOME/.nvm" ]]; then
        export NVM_DIR="$HOME/.nvm"
    else
        export NVM_DIR="$HOME/.config/nvm"
    fi
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

confirmation(){
    term_color_red
    echo "Install post tooling for node, python, go and rust?"
    echo "(cores 30..34 should already be installed)"
    echo
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        echo ""
        exit 1
    fi
}

# Run a section function; record but do not propagate its failure.
run_section(){
    local name="$1"; shift
    term_color_red
    echo ">>> $name"
    term_color_white

    if "$@"; then
        echo "--- $name: ok"
    else
        term_color_red
        echo "--- $name: FAILED (continuing)"
        term_color_white
        FAILED+=("$name")
    fi
}

install_node_tools(){
    packages=(
        "yarn"
        "@tailwindcss/language-server" # need for nvim tailwindcss cmp
        "vscode-langservers-extracted" # need for nvim tailwindcss cmp
        "typescript"                   # need for LSP
        "typescript-language-server"   # need for LSP
        "tsx"                          # need for transpile
    )

    for p in "${packages[@]}"; do
        echo "Install $p"
        npm install -no-fund -g "$p"
    done
}

install_python_tools(){
    # Pre-cache debugpy for nvim-dap. The adapter (z18-py.lua) launches:
    #   uv run --with debugpy python -m debugpy.adapter
    # Running it once here downloads debugpy into uv's cache, so the first
    # real debug session does not pay the resolve/download cost.
    uv run --python "${PYTHON_VERSION}" --with debugpy \
        python -c "import debugpy; print('debugpy', debugpy.__version__)"
}

install_go_tools(){
    # Internal tools
    go install -v golang.org/x/tools/cmd/goimports@latest
    go install -v golang.org/x/tools/cmd/callgraph@latest
    go install -v golang.org/x/tools/cmd/stringer@latest
    go install -v golang.org/x/tools/cmd/toolstash@latest

    # Unit test
    go install -v github.com/cweill/gotests/gotests@latest

    # Debugger
    go install -v github.com/go-delve/delve/cmd/dlv@latest

    # Go exec (and its usage)
    # goexec 'http.ListenAndServe(":8080", http.FileServer(http.Dir(".")))'
    go install -v github.com/shurcooL/goexec@latest

    go install github.com/sno6/gommand@latest

    # Bubble tea related
    go install -v github.com/maaslalani/slides@latest
}

install_rust_tools(){
    term_color_red
    echo "apt deps for cargo tools (openssl, LLVM/clang, dbus, udev)"
    term_color_white

    sudo apt install -y \
        pkg-config \
        libssl-dev \
        cmake \
        clang \
        ninja-build \
        libclang-dev \
        libdbus-1-dev \
        libudev-dev

    # https://github.com/rust-lang/cargo/wiki/Third-party-cargo-subcommands
    cargo install cargo-watch
    cargo install cargo-deb
    cargo install cargo-edit
    cargo install cargo-upgrades
    cargo install cargo-outdated
    cargo install cargo-make
    cargo install cargo-generate

    # Ducker - Docker TUI (moved from 22_tui_tools.sh; needs cargo, which only
    # exists after the rust core in 33_rust.sh).
    cargo install --git https://github.com/robertpsoane/ducker
}

post(){
    term_color_red
    if [[ ${#FAILED[@]} -eq 0 ]]; then
        echo "Done - all sections ok"
    else
        echo "Done - with failures:"
        for f in "${FAILED[@]}"; do
            echo "  - $f"
        done
    fi
    echo "- restart terminal, then run 50_nvim.sh / 51_astro_nvim.sh"
    term_color_white
}

trap term_color_white EXIT
setup_env
confirmation
run_section "node tools"   install_node_tools
run_section "python tools" install_python_tools
run_section "go tools"     install_go_tools
run_section "rust tools"   install_rust_tools
post
