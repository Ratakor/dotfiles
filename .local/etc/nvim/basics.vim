" Enable line number and relative number
set nu rnu

" Add a column at 80 characters
set colorcolumn=80
"let &colorcolumn = join(range(81,999), ',')

" indent
" could use shiftwidth=4 + expandtab
set smartindent
set tabstop=8 " n of whitespace in \t
set shiftwidth=8 " n of whitespace for indent
set softtabstop=8 " n of whitespace to delete with backspace
"set expandtab " \t -> whitespaces
autocmd FileType lisp,html set tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" remove the 'a' to disable the mouse
set mouse=a
aunmenu PopUp

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Map yank to the clipboard buffer
set clipboard+=unnamedplus
"set clipboard=unnamed

" better <C-d> and <C-u>
nnoremap <C-d> <C-d>zz
nnoremap <c-u> <c-u>zz

" Autocorrect
autocmd FileType html,markdown setlocal spell
autocmd FileType tex setlocal spell spelllang=fr
abbr hte the
