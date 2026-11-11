[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)

Ask for confirmation before quitting Vim.

I originally wrote this as [an answer on vi Stack
Exchange](http://vi.stackexchange.com/a/3712/51).

The idea is based on the ["ConfirmQuit"
script](http://www.vim.org/scripts/script.php?script_id=1072).

To use it you'll need to remap keys that "quit" Vim as there's no other way to
prevent Vim from quitting. This plugin comes with the following mappings by
default:

    cnoremap <expr> q<CR>  <SID>confirm_quit_cr('q', 0)
    cnoremap <expr> wq<CR> <SID>confirm_quit_cr('wq', 1)
    cnoremap <expr> x<CR>  <SID>confirm_quit_cr('x', 1)
    nnoremap <silent> ZZ   :call confirm_quit#confirm(1, 'last')<CR>

These command-line mappings apply only to `:q`, `:wq`, and `:x`. Searching
for `flex` is not rewritten.

See `:help confirm-quit` for the full documentation.

