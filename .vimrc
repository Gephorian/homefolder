execute pathogen#infect()
" filetype plugin indent on
syntax on

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" NERDTree and NERDCommenter configs are in .vim/plugins

" FuzzyFind
set rtp+=~/.fzf
map \ff :FZF<Enter>

" Prefs
color desert
set expandtab
set tabstop=4
set cursorline
set nu
set hlsearch
hi Cursorline term=bold cterm=bold
hi CursorLineNr term=bold cterm=underline ctermfg=11 gui=bold guifg=Yellow
hi ALEVirtualTextEditor guifg=red

" Keep working directory clean
set directory=~/.swp/,/tmp/
set backupdir=~/.backup/,/tmp/
set undodir=~/.undo/,/tmp/

" yamlfold
set foldlevelstart=10

" vim-terraform config
let g:terraform_fmt_on_save=1

" indentline
let g:indentLine_char = '⦙'

" Newline at the end of a file
" It's POSIX compliant I guess.
" set eol
