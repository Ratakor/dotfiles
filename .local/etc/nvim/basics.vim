" Enable line number and relative number
set nu rnu

" Add a column at 80 characters
if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=9
endif

" Theme
set background=dark
syntax enable
colorscheme dracula

" indentation
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
:filetype indent on
:filetype plugin on

" disable the mouse
set mouse=

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

" better j, k, 0 and $
" or use gqq
"nnoremap j gj
"nnoremap k gk
"nnoremap 0 g0
"nnoremap $ g$

" Autocorrect
"map <leader>o :setlocal spell! spelllang=en_us<CR>
"setlocal spell spelllang=en_US
abbr hte the
