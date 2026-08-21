#!/bin/bash

# Install external / networked services:
#   - Tailscale   (mesh VPN; installer adds the apt repo + a systemd service)
#   - Claude Code (Anthropic CLI; installs to ~/.local/bin, already on PATH)
#   - glab        (GitLab CLI; manage projects, branches, MRs, CI from the shell)
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
    echo "Install Tailscale, Claude Code, and glab?"
    echo "- Tailscale:   https://tailscale.com/download/linux"
    echo "- Claude Code: https://docs.claude.com/en/docs/claude-code"
    echo "- glab:        https://gitlab.com/gitlab-org/cli"
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

install_glab(){
    term_color_red
    echo "Install glab (GitLab CLI)"
    term_color_white

    ARCH_DEB=""
    CPU_TYPE=$(uname -m)
    if [[ $CPU_TYPE == "x86_64" ]]; then
        ARCH_DEB="amd64"
    elif [[ $CPU_TYPE == "aarch64" ]]; then
        ARCH_DEB="arm64"
    else
        term_color_red
        echo "Unsupported arch: $CPU_TYPE (x86_64 or aarch64 only)"
        term_color_white
        return 1
    fi

    # Latest release tag from the GitLab API (e.g. v1.114.0 -> 1.114.0)
    # -L is required: permalink/latest replies with a 302 redirect to the real release
    GLAB_TAG=$(curl -o- -sL "https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases/permalink/latest" | jq -r '.tag_name')
    GLAB_VERSION=${GLAB_TAG#v}
    echo "glab $GLAB_TAG ($ARCH_DEB)"

    mkdir -p /home/$LOGNAME/Downloads
    cd /home/$LOGNAME/Downloads
    rm -rf glab*.deb

    wget -O glab.deb \
        "https://gitlab.com/gitlab-org/cli/-/releases/${GLAB_TAG}/downloads/glab_${GLAB_VERSION}_linux_${ARCH_DEB}.deb"

    sudo dpkg -i glab.deb || sudo apt install -y -f
    rm -rf glab.deb

    cd -
}

post(){
    term_color_red
    echo "Done"
    echo "- Tailscale:   run \"sudo tailscale up\" to authenticate and join the tailnet"
    echo "               (\"tailscale status\" / \"tailscale ip\" to verify)"
    echo "- Claude Code: installed to ~/.local/bin (on PATH via .shrc)"
    echo "               run \"claude\" and follow the login prompt"
    echo "- glab:        authenticate with \"glab auth login --hostname gl.dev01.net\""
    echo "               (then \"glab auth status\" to verify; drop --hostname for gitlab.com)"
    echo
    echo "Restart terminal"
    term_color_white
}

trap term_color_white EXIT
confirmation
install_tailscale
install_claude_code
install_glab
post
