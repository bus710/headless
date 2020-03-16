
# by bus710/headless ================================
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

export PATH="$HOME/.cargo/bin:$PATH"

alias nv="nvim"
alias ll="ls -la"
alias gp="git pull"
alias gf="git fetch --dry-run -v"

alias ew="cd ~/repo"
alias hw="cd ~/repo/headless"
alias tw="cd ~/repo/scripts"
alias bw='cd ~/repo/blog'
alias dw='cd ~/repo/docs'
alias gw='cd ~/repo/gows'
alias gq='cd ~/repo/gqws'
alias fw='cd ~/repo/fltws'
alias pw='cd ~/repo/pyws'
alias rw='cd ~/repo/rustws'
alias ow='cd ~/repo/reactws'

alias av1='avahi-resolve -n -4 rpi3.local'
alias am='sudo minicom -b 115200 -o -D /dev/ttyUSB0'


