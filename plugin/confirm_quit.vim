" confirm_quit.vim: ask for confirmation before quitting Vim.
"
" http://code.arp242.net/confirm_quit.vim
"
" See the bottom of this file for copyright & license information.
"

"##########################################################
" Initialize some stuff
scriptencoding utf-8
if exists('g:loaded_confirm_quit') | finish | endif
let g:loaded_confirm_quit = 1
let s:save_cpo = &cpoptions
set cpoptions&vim


"##########################################################
" Mappings
if !(exists('g:confirm_quit_nomap') && g:confirm_quit_nomap)
	" q<CR>, wq<CR>, and x<CR> also match the end of a / or ? prompt.
	" Searching for "flex" would be rewritten to
	" fle:call confirm_quit#confirm(1, 'last') and Vim would report E486.
	" Confirm only when the Ex command is exactly q, wq, or x.
	cnoremap <expr> q<CR>  <SID>confirm_quit_cr('q', 0)
	cnoremap <expr> wq<CR> <SID>confirm_quit_cr('wq', 1)
	cnoremap <expr> x<CR>  <SID>confirm_quit_cr('x', 1)
	nnoremap <silent> ZZ     :call confirm_quit#confirm(1, 'last')<CR>
end

" The mapped keys are already removed from getcmdline() when this runs.
fun! s:confirm_quit_cr(cmd, writefile)
	let l:line = getcmdline()
	if l:line !~# a:cmd . '\s*$'
		let l:line .= a:cmd
	endif
	if getcmdtype() ==# ':' && l:line =~# '^\s*' . a:cmd . '\s*$'
		return "\<C-u>call confirm_quit#confirm(" . a:writefile . ", 'last')\<CR>"
	endif
	if getcmdline() =~# a:cmd . '\s*$'
		return "\<CR>"
	endif
	return a:cmd . "\<CR>"
endfun


"##########################################################
" Functions

" Ask for confirmation before quitting.
"
" If write_file is 1, the buffer will be written to disk (like :wq).
"
" With when, you can specify when to ask for confirmation. Possible values are:
"
"   - last: Last buffer (i.e. actually quitting)
"   - always: Always, even when just closing a window
fun! confirm_quit#confirm(writefile, when)
	if a:writefile && !s:write()
		return
	endif

	" TODO: Don't confirm for help windows, scratch buffer, etc.
	if a:when is? 'last' && !s:going_to_quit()
		quit
		return
	endif

	let l:confirmed = confirm('Do you really want to quit?', "&Yes\n&No", 2)
	if l:confirmed == 1
		quit
	endif
endfun


" Prevent quitting Vim altogether. The parameters work the same as
" confirm_quit#confirm()
fun! confirm_quit#prevent(writefile, when)
	if a:writefile && !s:write() | return | endif
	if a:when is? 'last' && !s:going_to_quit()
		quit
		return
	end

	echohl ErrorMsg | echomsg "You can't quit this way" | echohl None
endfun


" Run an alternative command when quiting. The {writefile} and {when} parameters
" work like |confirm_quit#confirm|, the {cmd} paramter is run with |:execute|.
fun! confirm_quit#command(writefile, when, cmd)
	if a:writefile && !s:write() | return | endif
	if a:when is? 'last' && !s:going_to_quit()
		quit
		return
	end

	execute a:cmd
endfun


"##########################################################
" Helper functions

" Write buffer to disk if modified
fun! s:write()
	if !&modified | return 1 | endif
	if expand('%') is? ''
		echohl ErrorMsg | echomsg 'E32: No file name' | echohl None
		return 0
	endif

	write
	return 1
endfun


" Check if we're actually going to quit Vim, rather than just closing the
" current window
fun! s:going_to_quit()
	return tabpagenr('$') is 1 && winnr('$') is 1
endfun


let &cpoptions = s:save_cpo
unlet s:save_cpo


" The MIT License (MIT)
"
" Copyright © 2015-2018 Martin Tournoij
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" The software is provided "as is", without warranty of any kind, express or
" implied, including but not limited to the warranties of merchantability,
" fitness for a particular purpose and noninfringement. In no event shall the
" authors or copyright holders be liable for any claim, damages or other
" liability, whether in an action of contract, tort or otherwise, arising
" from, out of or in connection with the software or the use or other dealings
" in the software.
