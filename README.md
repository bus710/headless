# Headless

To install these for headless x64 debian/ubuntu servers:
0. Global git config
1. Basic packages and environment variables
2. Go SDK
3. Flutter SDK
4. NodeJS for nvim
5. Nvim (appimage version)
7. Docker and Docker composer
9. Ufw and some configuration

<br/><br/>

## How to use

First of all, please check each of these to see what is the newest version:
- Go: https://golang.org/dl/
- Flutter: https://flutter.dev/docs/get-started/install/linux
- Docker-compose: https://github.com/docker/compose/releases

When each script (of Go, Flutter, and Docker) is being executed, it will show the version it will install and ask if the version is fine for you (if not, please edit the scripts).

Just run one by one in the terminal with **sudo** except Flutter.  

```sh
$ git clone https://github.com/bus710/headless
$ cd headless
$ chmod 744 *.sh

$ ./00_git_setup.sh
$ sudo ./01_basic_install.sh
$ source ~/.bashrc

$ sudo ./02_golang_install.sh
$      ./03_flutter_install.sh
$ sudo ./04_nodejs_install.sh
$ sudo ./05_nvim_install_plugin.sh
$ sudo ./07_docker_install.sh
$ sudo ./09_hardening.sh
```

Also, run this in nvim to install plug-ins of vim-plug and vim-go:
```sh
$ nvim

:PlugInstall
:GoInstallBinaries
```

<br/><br/>

## References

- [nvim](https://neovim.io/)
- [delve](https://github.com/go-delve/delve)
- [git](https://confluence.atlassian.com/bitbucketserver/basic-git-commands-776639767.html)
- [vim-plug](https://github.com/junegunn/vim-plug)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)
- [vim-go](https://github.com/fatih/vim-go)
- [vim-delve](https://github.com/sebdah/vim-delve)
- [vim-godebug](https://github.com/jodosha/vim-godebug)
- [dart-vim-plugin](https://github.com/dart-lang/dart-vim-plugin)
- [vim-flutter](https://github.com/thosakwe/vim-flutter)
- [vim-markdown-preview](https://github.com/iamcco/markdown-preview.nvim)
- [Learn Vimscript the Hardway](http://learnvimscriptthehardway.stevelosh.com)
- [My neovim setup for Go](https://hackernoon.com/my-neovim-setup-for-go-7f7b6e805876)


