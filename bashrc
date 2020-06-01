
# by bus710/headless ================================

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '

export PATH=$PATH:$HOME/.tools
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
export GOPATH=$HOME/go

export DELVE_EDITOR=nvim

export PATH=$PATH:$HOME/flutter/bin
export PATH=$PATH:$HOME/flutter/bin/cache/dart-sdk/bin
export PATH=$PATH:$HOME/flutter/.pub-cache/bin

export JAVA_HOME=$HOME/android-studio/jre
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$HOME/android-studio/bin:$PATH
export PATH=$HOME/Android/Sdk/tools/bin:$PATH
export PATH=$HOME/Android/Sdk/platform-tools:$PATH

alias nv="nvim"
alias ll="ls -la"
alias gp="git pull"
alias gf="git fetch --dry-run -v"

alias ew="cd ~/repo"
alias hw="cd ~/repo/headless"
alias tw="cd ~/repo/scripts"
alias bw='cd ~/repo/blog'
alias cl='cd ~/repo/cloud'
alias dw='cd ~/repo/docs'
alias gw='cd ~/repo/gows'
alias gq='cd ~/repo/gqws'
alias fw='cd ~/repo/fltws'
alias pw='cd ~/repo/pyws'
alias rw='cd ~/repo/rustws'
alias ow='cd ~/repo/reactws'
alias lw='cd ~/repo/leetcode-go'
alias tp='cat /sys/class/thermal/thermal_zone0/temp'

alias av1='avahi-resolve -n -4 rpi3.local'
alias am='sudo minicom -b 115200 -o -D /dev/ttyUSB0'
alias an='sudo minicom -b 9600 -o -D /dev/ttyACM0'


