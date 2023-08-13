set autoindent
set smartindent
set tabstop=8 " n of whitespace in \t
set shiftwidth=8 " n of whitespace for indent
set softtabstop=8 " n of whitespace to delete with backspace
"set expandtab " \t -> whitespaces

"set mouse=
aunmenu PopUp

set number
set relativenumber
set colorcolumn=80
"set textwidth=79
set title
set termguicolors
set clipboard+=unnamedplus
set ttimeoutlen=10
set list
set lcs=tab:\|\ ,space:⋅ ",eol:$ "↴
set path=.,/usr/include,/usr/local/include,,
set nofoldenable
autocmd FileType * setl fo-=ro fo+=tc

cabbrev Q q
iabbrev reutnr return
iabbrev TOOD TODO

nnoremap <silent> <C-L> :nohls<C-R>=has('diff')?'<Bar>dif':''<CR><CR><C-L>
nnoremap <C-d> <C-d>zz
nnoremap <c-u> <c-u>zz
nnoremap ZQ :q<CR>

" Language specific
autocmd FileType python setl ts=4 sw=4 sts=4 expandtab
autocmd FileType lisp,html setl ts=2 sw=2 sts=2 expandtab
autocmd FileType html,markdown setl spell
autocmd FileType tex setl spell spl=fr
autocmd FileType c setl makeprg=cc\ %:p
" -j or -xj
autocmd BufWritePost *.c silent !astyle -A3 -t8 -p -xg -H -xB -U -n %:p
autocmd BufWritePost *.go silent !gofmt -s -w %:p
command Astyle !astyle -A3 -t8 -p -xg -H -xB -U -n -w %:p
command GoBuild !go build %:p
