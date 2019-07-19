" To activate this, please store it in ~/.config/nvim/ 
" Refrences
" - https://vimhelp.org/quickref.txt.html
" - https://devhints.io/vimscript

" Variables
let hostname = substitute(system('hostname'), '\n', '', '')
let whoami = substitute(system('whoami'), '\n', '', '')
let name = hostname . "/" . whoami " Concat the strings

if hostname == "test"
endif

" Autocommand - these file types need tabstop 4 when being read.
au BufRead,BufNewFile *.dart,*.md,*.go,*py,*pyw,*.c,*.h,*.js,*.html,*.css set tabstop=4

" Options <interface>
set number
set laststatus=2
set statusline=%{name}
"set lines=60 columns=100 " If really want

" Options <tab size>
set ts=4 
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Options <encoding>
set langmenu=utf-8
set encoding=utf-8
set fileencodings=utf-8,euckr
set fencs=utf-8,euc-kr,cp949,cp932,euc-jp,shift-jis,big5,latin1,ucs-2le

" Options <etc>
set modelines=0 " For security

" Folding related
set fdm=indent
set fdc=4
set fdl=1
set foldlevelstart=20

" Filetype related
filetype plugin indent on

" Vim-Plug related. Do :PlugInstall
call plug#begin('~/.config/nvim/plugged')
Plug 'roxma/nvim-completion-manager'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe', { 'do': '/usr/bin/python3 ./install.py --clang-completer --go-completer'}
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'Shougo/vimshell.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'sebdah/vim-delve'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim'
" Color Themes
Plug 'dracula/vim'
"Plug 'tomasiser/vim-code-dark'
"Plug 'sickill/vim-monokai'
"Plug 'ayu-theme/ayu-vim'
"Plug 'vim-syntastic/syntastic' " This makes some delay on dart files
call plug#end()

" Color settings should come after Vim-Plug config
set termguicolors
set t_Co=256
syntax on
color dracula
colorscheme dracula

" Short-cuts
nmap <C-t> :TagbarToggle<CR>
nmap <C-n> :NERDTreeToggle<CR>

" Plug-in variables
let g:flutter_hot_reload_on_save = 0
let g:flutter_hot_restart_on_save = 0
