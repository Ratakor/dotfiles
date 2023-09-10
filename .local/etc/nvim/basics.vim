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
set colorcolumn=80,100
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
cabbrev W w
iabbrev reutnr return
iabbrev TOOD TODO

nnoremap <silent> <C-L> :nohls<C-R>=has('diff')?'<Bar>dif':''<CR><CR><C-L>
"nnoremap <C-P> :autocmd! BufWritePost *.c<CR>
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap ZQ :q<CR>

" Language specific
autocmd FileType python setl ts=4 sw=4 sts=4 expandtab
autocmd FileType lisp,html setl ts=2 sw=2 sts=2 expandtab
"autocmd FileType html,markdown setl spell
"autocmd FileType tex setl spell spl=fr
autocmd FileType c setl makeprg=cc\ %:p
autocmd BufWritePost *.c silent !astyle -A3 -t8 -p -xg -H -xB -U -n %:p
autocmd BufWritePost *.go silent !gofmt -s -w %:p
command Astyle !astyle -A3 -t8 -p -xg -H -xB -U -n -w -j %:p
command GoBuild !go build %:p
