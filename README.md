# Headless

To install these:
1. basic packages and environment variables
2. Go SDK
3. Flutter/Web SDK (not for mobile)
4. nvim (appimage version), vim-plug, some plug-ins, and dracula theme
5. Docker and Docker composer
6. ufw and some configuration

for headless debian/ubuntu servers.

## How to use

Just run one by one in the terminal with **sudo**.
(Flutter and Delve don't need the sudo permission.)

```
$ git clone https://github.com/bus710/headless
$ cd headless
$ chmod 744 *.sh

$ sudo 01_basic_install.sh
$ sudo 02_golang_install.sh
$      03_flutter_install.sh
$ sudo 04_nvim_install_plugin.sh
$ sudo 05_docker_install.sh
$ sudo 06_hardening.sh

$ go get -u github.com/go-delve/delve/cmd/dlv
```

## Start a new project

Go can be started from **go mod init main**.

Flutter/Web can be started from the scratch:
- Please check the **sample_flutter_web**
- Also, don't forget running **flutter packages get** in the directory.

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
- [My neovim setup for Go](https://hackernoon.com/my-neovim-setup-for-go-7f7b6e805876)

## Cheatsheets

WIP
