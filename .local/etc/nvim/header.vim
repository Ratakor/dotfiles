"                                                      .     :-. .
"    author:  ratakor <ratakor@disroot.org>            :*==*%%%#%+=---:
"                                                       :#%%%*+%#=+%*:.
"    created: Sat, 06 May 2023 18:54:06 +0200            :%%%. .   -*%-
"    updated: Sat, 13 May 2023 13:16:03 +0200             =## .   :#%*=:.
"                                                         -#*#%:=#%%%#-
"    description:                                        *:*%%%%%%%#-
"    script to produce an header like this one            .-#%%%%%%+
"    automaticaly for each new file                        %%%--%%%%*-
"                                                         ##%=  +%%=:..
"                                                          #*    #%#
"                                                         :#     -==*
"                                                         ::        .:

let s:ascii = [
              \"",
	      \".     :-. .",
              \":*==*%%%#%+=---:",
              \" :#%%%*+%#=+%*:.",
              \"  :%%%. .   -*%-",
              \"   =## .   :#%*=:.",
              \"   -#*#%:=#%%%#-",
              \"  *:*%%%%%%%#-",
              \"   .-#%%%%%%+",
              \"    %%%--%%%%*-",
              \"   ##%=  +%%=:..",
              \"    #*    #%#",
              \"   :#     -==*",
              \"   ::        .:",
              \]

let s:start   = '#'
let s:mid     = '#'
let s:end     = ''
let s:size    = 20 " ascii width
let s:length  = len(s:ascii) " header length
let s:width   = 80 " header width
let s:margin  = 5

let s:types   = {
                \'\.c$\|\.h$\|\.cc$\|\.hh$\|\.cpp$\|\.hpp$\|\.cs$\|\.php$':
                \['/*', ' *', ' */'],
                \'\.htm$\|\.html$\|\.xml$\|\.md$':
                \['<!--', ' ', '-->'],
                \'\.js$':
                \['//', '//', ''],
                \'\.tex$':
                \['%', '%', ''],
                \'\.ml$\|\.mli$\|\.mll$\|\.mly$':
                \['(*', ' ', '*)'],
                \'\.vim$\|\vimrc$':
                \['"', '"', ''],
                \'\.f90$\|\.f95$\|\.f03$\|\.f$\|\.for$':
                \['!', '!', ''],
                \'\.zig$':
                \['///', '///', ''],
                \}

function! s:filetype()
	let l:f = expand("%:t")

	for type in keys(s:types)
		if l:f =~ type
			let s:start = s:types[type][0]
			let s:mid   = s:types[type][1]
			let s:end   = s:types[type][2]
		endif
	endfor

endfunction

function! s:textline(txt, pos)
	let l:txt = strpart(a:txt, 0, s:width - s:margin * 2 - s:size)

	if a:pos == 1
		return s:start . repeat(' ', s:margin - strlen(s:start)) . l:txt . repeat(' ', s:width - s:margin * 2 - strlen(l:txt) - s:size) . s:ascii[a:pos]
	elseif a:pos == s:length
		return s:end
	else
		return s:mid . repeat(' ', s:margin - strlen(s:start)) . l:txt . repeat(' ', s:width - s:margin * 2 - strlen(l:txt) - s:size) . s:ascii[a:pos]
endfunction

function! s:line(n)
	if a:n == 2
		return s:textline("author:  " . s:user() . " <" . s:mail() . ">", a:n)
"	elseif a:n == 3
"		return s:textline("license: " . "ICS license", a:n)
	elseif a:n == 4
		return s:textline("created: " . s:date(), a:n)
	elseif a:n == 5
		return s:textline("updated: " . s:date(), a:n)
	elseif a:n == 7
		return s:textline("description: ", a:n)
	else
		return s:textline('',  a:n)
	endif
endfunction

function! s:user()
	let l:user = $USER
	if strlen(l:user) == 0
		let l:user = "user"
	endif
	return l:user
endfunction

function! s:mail()
	let l:mail = $MAIL
	if strlen(l:mail) == 0
		let l:mail = "user@mail.org"
	endif
	return l:mail
endfunction

function! s:date()
	return strftime("%a, %d %b %Y %H:%M:%S %z")
endfunction

function! s:insert()
	let l:line = s:length

	while l:line > 0
		call append(0, s:line(l:line))
		let l:line = l:line - 1
	endwhile
endfunction

function! s:update()
	let line = 0
	call s:filetype()
	if getline(5) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "updated: "
		let line = 5
	elseif getline(6) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "updated: "
		let line = 6
	endif
	if line > 0 && &mod
		call setline(line, s:line(5))
		return 0
	endif
	return 1
endfunction

function! s:header()
	if s:update()
		call s:insert()
	endif
endfunction

command! Header call s:header ()
autocmd BufNewFile  * call s:header ()
autocmd BufWritePre * call s:update ()
