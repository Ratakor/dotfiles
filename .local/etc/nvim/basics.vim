" Indent
set autoindent
set smartindent
set tabstop=8 " n of whitespace in \t
set shiftwidth=8 " n of whitespace for indent
set softtabstop=8 " n of whitespace to delete with backspace
"set expandtab " \t -> whitespaces

" Disable the mouse, btw use shift for highlighting
"set mouse=
aunmenu PopUp

" better <C-d> and <C-u>
nnoremap <C-d> <C-d>zz
nnoremap <c-u> <c-u>zz

" Misc
set number
set relativenumber
set colorcolumn=80
"set textwidth=79
set title
set termguicolors
set clipboard+=unnamedplus
"set list
"set lcs=tab:\|\ ,space:⋅,eol:$ "↴
autocmd FileType * setl fo-=ro fo+=tc
abbreviate hte the
nnoremap :Q<CR> :q<CR>
nnoremap :Q!<CR> :q!<CR>
set ttimeoutlen=10
nnoremap <silent> <C-L> :nohls<C-R>=has('diff')?'<Bar>dif':''<CR><CR><C-L>

" Language specific
autocmd FileType python setl ts=4 sw=4 sts=4 expandtab
autocmd FileType lisp,html setl ts=2 sw=2 sts=2 expandtab
autocmd FileType html,markdown setl spell
autocmd FileType tex setl spell spl=fr
autocmd FileType c setl makeprg=cc\ %:p
autocmd BufWritePost *.c silent! !astyle -A3 -t8 -p -xg -H -xB -n -w %:p
command Astyle !astyle -A3 -t8 -p -xg -H -xB -n -w %:p
