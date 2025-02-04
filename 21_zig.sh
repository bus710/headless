#!/bin/bash

set -e

CPU_TARGET=""
ZIG_RELEASE_URL=https://api.github.com/repos/ziglang/zig/releases/latest
ZIG_RELEASE=""
ZLS_RELEASE_URL=https://api.github.com/repos/zigtools/zls/releases/latest
ZLS_RELEASE=""
ZIG_FILE_NAME=""
ZLS_FILE_NAME=""

ZIG_RELEASE_URL_MASTER=https://ziglang.org/download/index.json 
ZIG_RELEASE_MASTER=""
ZIG_FILE_NAME_MASTER=""

TARGET="master"

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

check_architecture_and_version_master(){
    CPU_TARGET=$(uname -m)
    if [[ $CPU_TARGET != "x86_64" && $CPU_TARGET != "aarch64" ]]; then
        exit
    fi

    ZIG_RELEASE_MASTER=$(curl -o- -s $ZIG_RELEASE_URL_MASTER | jq -r '.master.version')
    ZIG_FILE_NAME_MASTER=https://ziglang.org/builds/zig-linux-${CPU_TARGET}-${ZIG_RELEASE_MASTER}.tar.xz
}


confirmation(){
    term_color_red
    echo "What will happen:"
    echo "- Remove ~/zig"
    echo "- Install llvm and lldb"
    echo "- Install zig and zls from stable or master"
    echo "- Stable zig $ZIG_RELEASE and zls $ZLS_RELEASE"
    echo "- Master zig $ZIG_RELEASE_MASTER and zls building on the fly"
    echo
    echo "Do you want to proceed? (m/s/n)"
    term_color_white

    read -n 1 ans
    echo

    if [[ $ans == "s" ]]; then
        TARGET="stable"
    elif [[ $ans == "m" || $ans == "y" ]]; then
        TARGET="master"
    else
        exit 1
    fi

    echo "The target version is $TARGET"
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

    echo $TARGET
    echo $ZIG_FILE_NAME_MASTER

    if [[ $TARGET == "stable" ]]; then
        wget ${ZIG_FILE_NAME}
    else
        wget ${ZIG_FILE_NAME_MASTER}
    fi

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

build_zls(){
    term_color_red
    echo "Clone and Zig Language Server"
    term_color_white

    cd /home/${LOGNAME}/zig
    rm -rf zls*
    git clone git@github.com:zigtools/zls.git zlsRepo

    source /home/${LOGNAME}/.shrc

    cd zlsRepo
    zig build -Doptimize=ReleaseSafe
    mv zig-out/bin/zls /home/$LOGNAME/zig/

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
check_architecture_and_version_master
confirmation
cleanup
install_llvm
install_zig
configure_runcom
configure_zls_config

if [[ $TARGET == "stable" ]]; then
    install_zls
else
    build_zls
fi

post
