set encoding=utf-8
set ffs=unix,dos,mac

set ruler
set number
set relativenumber

set laststatus=2 "always show the status line

set tabstop=4
set shiftwidth=4 
set expandtab "spaces, not tabs
set autoindent
set smartindent

set colorcolumn=120

set splitbelow
set splitright

set ignorecase
set smartcase
set hlsearch
set incsearch
set lazyredraw
set magic 
set mat=2

set foldcolumn=1

"Colors and Fonts
syntax enable
colorscheme slate
set background=dark

"Markdown support
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.md set spell

" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
"TMUX support
set mouse=a
if exists('$TMUX')
    set ttymouse=xterm2
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    "let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    "let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
endif
