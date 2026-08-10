#!/bin/bash

set -e

# Install uv (Python package / venv / interpreter manager) and a uv-managed
# Python interpreter. uv installs to ~/.local/bin, which is already on PATH
# (see .shrc), so no runcom edits are needed here.
# The debugpy pre-cache for nvim-dap lives in 40_sdk_tools.sh.

PYTHON_VERSION="3.12"

if [[ "$EUID" == 0 ]]; then
    echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

install_uv(){
    term_color_red
    echo "Install / update uv"
    term_color_white

    if command -v uv >/dev/null 2>&1; then
        uv self update || true
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi

    # Make uv visible to the rest of this script (installer target dir).
    export PATH="$HOME/.local/bin:$PATH"
    uv --version
}

install_python(){
    term_color_red
    echo "Install Python ${PYTHON_VERSION} via uv"
    term_color_white

    uv python install "${PYTHON_VERSION}"
    uv python list
}

post(){
    term_color_red
    echo "Done"
    term_color_white

    echo "Per project:  uv init   (new project)"
    echo "              uv sync   (create .venv + install deps)"
    echo "Launch nvim from the project root so LSP/DAP find .venv."
    echo ""
    echo "DAP gotcha: 'uv: Launch file' runs the open file as a script, so"
    echo "breakpoints only hit in code that actually executes at import time."
    echo "A fresh 'uv init' leaves src/<pkg>/__init__.py defining main() but"
    echo "never calling it, so debugging that file stops nothing. Make the"
    echo "file runnable before debugging, e.g. add to the entry module:"
    term_color_red
    echo "    if __name__ == \"__main__\":"
    echo "        main()"
    term_color_white
    echo "or add src/<pkg>/__main__.py ('from <pkg> import main; main()') and"
    echo "use 'uv: Launch module' with module <pkg> (needed once you have"
    echo "package-relative imports)."
}

trap term_color_white EXIT
install_uv
install_python
post
