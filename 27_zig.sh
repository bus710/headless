#!/bin/bash

set -e

CPU_TARGET=""
RELEASES_URL=https://ziglang.org/download/index.json
VERSION=""
FILE_NAME=""

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

check_architecture_and_version(){
    CPU_TARGET=$(uname -m)
    FILTER=""
    if [[ $CPU_TARGET =~ "x86_64" ]]; then
        FILTER='.[].master."x86_64-linux".tarball'
    elif [[ $CPU_TARGET =~ "aarch64" ]]; then
        FILTER='.[].master."aarch64-linux".tarball'
    else
        exit
    fi
    FILE_NAME=$(curl -s ${RELEASES_URL} | \
        jq --raw-output --slurp $FILTER)
}

confirmation(){
    term_color_red
    echo "What will happen:"
    echo "- Remove ~/zig"
    echo "- Install $VERSION"
    echo
    echo "Do you want to proceed? (y/n)"
    term_color_white

    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then
        exit 1
    fi
}

cleanup(){
    term_color_red
    echo "Clean-up"
    term_color_white

    # Remove if there is old tarballs
    rm -rf zig*.tar.gz*
    rm -rf /home/$LOGNAME/zig
}

install(){
    term_color_red
    echo "Download and install Zig"
    term_color_white

    cd /home/${LOGNAME}
    wget ${FILE_NAME}

    term_color_red
    echo "Wait for untar..."
    term_color_white

    tar xf zig-linux-*.tar.xz
    rm -rf zig*.tar.xz
    mv zig-linux-* zig
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/zig
}

configure_runcom(){
    term_color_red
    echo "Configure runcom"
    term_color_white

    if [[ -f /home/$LOGNAME/zig/zig ]]; then
        sed -i '/\#ZIG_0/c\export PATH=$PATH:\/home\/$LOGNAME\/zig' /home/$LOGNAME/.shrc
    fi

    # source /home/$LOGNAME/.shrc
}

install_zls(){
    term_color_red
    echo "Download and install Zig Language Server"
    term_color_white

    cd /home/${LOGNAME}/zig

    rm -rf zls*
    git clone --recurse-submodules https://github.com/zigtools/zls zlsRepo
    cd /home/$LOGNAME/zig/zlsRepo
    /home/$LOGNAME/zig/zig build -Doptimize=ReleaseSafe
    mv ./zig-out/bin/zls /home/$LOGNAME/zig
    cd /home/$LOGNAME/zig
    rm -rf /home/$LOGNAME/zig/zlsRepo
}

install_llvm(){
    term_color_red
    echo "Install LLVM and LLDB"
    term_color_white

    sudo apt install -y llvm lldb
}

post(){
    term_color_red
    echo "Done"
    echo "- Restart terminal"
    echo "- Run \"mkdir hello-world && cd hello-world && zig init\" to start a new Zig project"
    echo "- Run \"zls --config-path \$SOMEWHERE\" to specify the location of zls.json"
    echo "- Run \"cp-zig-vscode\" to copy VSCODE configurations into the current path"
    echo "- Press \"<Space>d-c\" to start a debugging session in AstroNvim" 
    echo "  (will be asked the path to the executable. Then zig-out/bin/\$BASENAME)"
    term_color_white
}

trap term_color_white EXIT
check_architecture_and_version
confirmation
cleanup
install
configure_runcom
install_zls
install_llvm
post
