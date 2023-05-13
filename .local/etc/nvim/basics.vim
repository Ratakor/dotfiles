" Indent
set autoindent smartindent
set tabstop=8 " n of whitespace in \t
set shiftwidth=8 " n of whitespace for indent
set softtabstop=8 " n of whitespace to delete with backspace
"set expandtab " \t -> whitespaces
"set list
"set lcs=tab:\|\ ,space:⋅,eol:$ "↴

" Disable the mouse, btw use shift for highlighting
"set mouse=
map <Middlemouse> <Nop>
imap <Middlemouse> <Nop>
aunmenu PopUp

" better <C-d> and <C-u>
nnoremap <C-d> <C-d>zz
nnoremap <c-u> <c-u>zz

" Autocorrect
abbr hte the

" Misc
set nu rnu
set cc=80
set tw=79
set title
set nohls
set tgc
set clipboard+=unnamedplus
autocmd FileType * setl fo-=ro fo+=tc

" Language specific
autocmd FileType python setl ts=4 sw=4 sts=4 expandtab
autocmd FileType lisp,html setl ts=2 sw=2 sts=2 expandtab
autocmd FileType html,markdown setl spell
autocmd FileType tex setl spell spl=fr
autocmd BufWritePost *.c silent! !astyle -A3 -t8 -p -xg -H -xB -n %:p
