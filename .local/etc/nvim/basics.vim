" Enable line number and relative number
set nu rnu

" Add a column at 80 characters
set colorcolumn=80
"let &colorcolumn = join(range(81,999), ',')

" Theme
set background=dark
syntax enable
colorscheme dracula

" indentation
set autoindent
set tabstop=8 " n of whitespace in \t
set shiftwidth=8 " n of whitespace for indent
set softtabstop=8 " n of whitespace to delete with backspace
"set expandtab " \t -> whitespaces
"set smarttab

" disable the mouse
set mouse=a

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Map yank to the clipboard buffer
set clipboard+=unnamedplus
"set clipboard=unnamed

" better <C-d> and <C-u>
nnoremap <C-d> <C-d>zz
nnoremap <c-u> <c-u>zz

" Move between buffers
nnoremap <C-J> :bprev<CR>
nnoremap <C-K> :bnext<CR>

" Autocorrect
"map <leader>o :setlocal spell! spelllang=en_us<CR>
"setlocal spell spelllang=en_US
abbr hte the
