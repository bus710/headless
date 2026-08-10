#!/bin/bash

# Install external / networked services:
#   - Tailscale   (mesh VPN; installer adds the apt repo + a systemd service)
#   - Claude Code (Anthropic CLI; installs to ~/.local/bin, already on PATH)
#
# Claude Code can also be installed via npm (needs 30_node.sh):
#   npm install -g @anthropic-ai/claude-code
# The native installer below is self-contained and self-updating.

set -e

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

confirmation(){
    term_color_red
    echo "Install Tailscale and Claude Code?"
    echo "- Tailscale:   https://tailscale.com/download/linux"
    echo "- Claude Code: https://docs.claude.com/en/docs/claude-code"
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

install_tailscale(){
    term_color_red
    echo "Install Tailscale"
    term_color_white

    curl -fsSL https://tailscale.com/install.sh | sh
}

install_claude_code(){
    term_color_red
    echo "Install Claude Code"
    term_color_white

    curl -fsSL https://claude.ai/install.sh | bash
}

post(){
    term_color_red
    echo "Done"
    echo "- Tailscale:   run \"sudo tailscale up\" to authenticate and join the tailnet"
    echo "               (\"tailscale status\" / \"tailscale ip\" to verify)"
    echo "- Claude Code: installed to ~/.local/bin (on PATH via .shrc)"
    echo "               run \"claude\" and follow the login prompt"
    echo 
    echo "Restart terminal"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_tailscale
install_claude_code
post
