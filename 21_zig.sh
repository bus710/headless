#!/bin/bash

set -e

CPU_TARGET=""
ZIG_RELEASE_URL=https://api.github.com/repos/ziglang/zig/releases/latest
ZIG_RELEASE=""
ZLS_RELEASE_URL=https://api.github.com/repos/zigtools/zls/releases/latest
ZLS_RELEASE=""
ZIG_FILE_NAME=""
ZLS_FILE_NAME=""

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
    if [[ $CPU_TARGET != "x86_64" && $CPU_TARGET != "aarch64" ]]; then
        exit
    fi

    ZIG_RELEASE=$(curl -o- -s $ZIG_RELEASE_URL | jq -r '.tag_name')
    ZLS_RELEASE=$(curl -o- -s $ZLS_RELEASE_URL | jq -r '.tag_name')
    ZIG_FILE_NAME=https://ziglang.org/download/${ZIG_RELEASE}/zig-linux-${CPU_TARGET}-${ZIG_RELEASE}.tar.xz
    ZLS_FILE_NAME=https://github.com/zigtools/zls/releases/download/${ZLS_RELEASE}/zls-${CPU_TARGET}-linux.tar.xz
}

confirmation(){
    term_color_red
    echo "What will happen:"
    echo "- Remove ~/zig"
    echo "- Install llvm and lldb"
    echo "- Install zig $ZIG_RELEASE"
    echo "- Install zls $ZLS_RELEASE"
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

install_llvm(){
    term_color_red
    echo "Install LLVM and LLDB"
    term_color_white

    sudo apt install -y llvm lldb
}

install_zig(){
    term_color_red
    echo "Install Zig"
    term_color_white

    cd /home/${LOGNAME}
    wget ${ZIG_FILE_NAME}

    term_color_red
    echo "Wait for untar..."
    term_color_white

    tar xf zig-linux-*.tar.xz
    rm -rf zig*.tar.xz
    mv zig-linux-* zig
    chown $LOGNAME:$LOGNAME /home/$LOGNAME/zig
}

install_zls(){
    term_color_red
    echo "Download and install Zig Language Server"
    term_color_white

    cd /home/${LOGNAME}/zig
    rm -rf zls*
    wget ${ZLS_FILE_NAME}
    mkdir zlsRepo

    term_color_red
    echo "Wait for untar..."
    term_color_white

    tar xf zls-${CPU_TARGET}-linux.tar.xz -C zlsRepo

    mv zlsRepo/zls .
    rm -rf zls-*
    rm -rf zlsRepo

    cd /home/$LOGNAME/repo/headless
}

configure_runcom(){
    term_color_red
    echo "Configure runcom"
    term_color_white

    if [[ -f /home/$LOGNAME/zig/zig ]]; then
        sed -i '/\#ZIG_0/c\export PATH=$PATH:\/home\/$LOGNAME\/zig' /home/$LOGNAME/.shrc
    fi
}

configure_zls_config(){
    term_color_red
    echo "Configure zls"
    echo "- Options: https://github.com/zigtools/zls/wiki/Configuration"
    term_color_white

    cp /home/$LOGNAME/repo/headless/sdk/zig/zls.json /home/$LOGNAME/.config/zls.json
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
install_llvm
install_zig
configure_runcom
configure_zls_config
install_zls
post
