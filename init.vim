" To activate this, please store it in ~/.config/nvim/
" Refrences
" - https://vimhelp.org/quickref.txt.html
" - https://devhints.io/vimscript

" ==========================================================
set nocompatible              " be iMproved, required
filetype plugin indent off    " required

" ==========================================================
" Variables
let hostname = substitute(system('hostname'), '\n', '', '')
let whoami = substitute(system('whoami'), '\n', '', '')
let name = hostname . "/" . whoami " Concat the strings

if hostname == "test"
endif

" ==========================================================
" Autocommand - these file types need tabstop 4 when being read.
au BufRead,BufNewFile *.dart,*.md,*.go,*py,*pyw,*.c,*.h,*.js,*.html,*.css,*.kt set tabstop=4
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType c ClangFormatAutoEnable

" ==========================================================
" Autocommand - gofmt at writing
set rtp+=$GOROOT/misc/vim
autocmd BufWritePost *.go :silent !gofmt -w %

" ==========================================================
" Options <interface>
set number
set laststatus=2
set statusline=%{name} " see how to use variable
"set lines=60 columns=100 " If really want

" Options <tab size>
set ts=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set cindent
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

" Copy/paste - this needs xclip installed
set clipboard+=unnamedplus

" ==========================================================
" Vim-Plug related. Do :PlugInstall
call plug#begin('~/.config/nvim/plugged')
" Basics
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " file tap
Plug 'majutsushi/tagbar' " ctags should be installed
Plug 'godlygeek/tabular' " https://devhints.io/tabular (:Tab /=)
Plug 'ncm2/ncm2'        " use the ^n key combo to pick a candidate
Plug 'Shougo/deol.nvim' " try :Deol in nvim (this replaces Shougo/vimshell.vim)
Plug 'Shougo/vimproc.vim', { 'do': 'make' } " for async exec.
Plug 'vim-airline/vim-airline' " for the nice status bar + @
Plug 'tpope/vim-fugitive' " for git in nvim
Plug 'airblade/vim-gitgutter' " To see if a file changed after the last commit
Plug 'ctrlpvim/ctrlp.vim' " file finding: this can be helpful for the speed => g:ctrlp_custom_ignore
" Snippet related
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" COC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Linter
Plug 'w0rp/ale'
" Go
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'sebdah/vim-delve' " a bridge between dlv and nvim
" Rust
Plug 'rust-lang/rust.vim'
" Dart/Flutter
"Plug 'dart-lang/dart-vim-plugin'
"Plug 'thosakwe/vim-flutter'
" Markdown
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim'
" Color Themes
Plug 'dracula/vim'
"Plug 'tomasiser/vim-code-dark'
"Plug 'sickill/vim-monokai'
"Plug 'ayu-theme/ayu-vim'
"Plug 'vim-syntastic/syntastic' " This makes some delay on dart files
Plug 'stephpy/vim-yaml'
" Erlang
"Plug 'vim-erlang/vim-erlang-runtime'
"Plug 'vim-erlang/vim-erlang-compiler'
"Plug 'vim-erlang/vim-erlang-omnicomplete'
"Plug 'vim-erlang/vim-erlang-tags'
" Elixir
"Plug 'elixir-editors/vim-elixir'
"Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
" Zig
"Plug 'ziglang/zig.vim'
" Svelte
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
call plug#end()

" ==========================================================
" Color settings should come after Vim-Plug config
set termguicolors
set t_Co=256
syntax on
color dracula
colorscheme dracula

" ==========================================================
" Some good guides for shortcuts and variables
" - https://hackernoon.com/my-neovim-setup-for-go-7f7b6e805876
" - https://tpaschalis.github.io/vim-go-setup/

" Shortcuts
let mapleader = ","
nmap <C-t> :TagbarToggle<CR>
nmap <C-n> :NERDTreeToggle<CR>

" Shortcuts for Go
" - https://github.com/sebdah/vim-delve
au Filetype go nmap gdr :GoRun<CR>
au Filetype go nmap gdd :DlvDebug<CR>
au Filetype go nmap gdt :DlvToggleBreakpoint<CR>
"au Filetype go nmap <leader>gah <Plug>(go-alternate-split)
"au Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)

" Shortcuts of Delve cli
" - https://github.com/go-delve/delve/tree/master/Documentation/cli
" - next (n): to go to the next code line
" - continue (c): to go to the next breakpoint
" - breakpoints: to see the breakpoints
" - clear breakpoint-id: to delete a breakpoint
" - print (p) variable-name: to print the content of a var
" - goroutines/goroutine: to play with go-routines

" ==========================================================
" Plug-in variables

" Clang_complete - path to directory where library can be found
" let g:clang_library_path='/usr/lib/llvm-11/lib'

" Don't do hot-reload for flutter when save.
let g:flutter_hot_reload_on_save = 0
let g:flutter_hot_restart_on_save = 0
" Error and warning signs.
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
" Enable integration with airline.
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' '
let g:airline_symbols.maxlinenr= ''
let g:airline_symbols.colnr = ' '

" Make Delve to be backend
let g:delve_backend = "native"
" Put imports when save
let g:go_fmt_command = "goimports"
" Neovim Python3 provider
let g:python3_host_prog=expand('/usr/bin/python3')
" ==========================================================
filetype plugin indent on    " required
