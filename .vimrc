execute pathogen#infect()
" filetype plugin indent on
syntax on

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" NERDTree
let NERDTreeQuitOnOpen=1

function! s:CloseIfOnlyControlWinLeft()
  if winnr("$") != 1
    return
  endif
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        \ || &buftype == 'quickfix'
    q
  endif
endfunction
augroup CloseIfOnlyControlWinLeft
  au!
  au BufEnter * call s:CloseIfOnlyControlWinLeft()
augroup END

map \bb :NERDTree<enter>

" NERDCommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDToggleCheckAllLines = 1
map \cc <plug>NERDCommenterToggle

" FuzzyFind
set rtp+=~/.fzf
map \ff :FZF<Enter>

" Prefs
color desert
set expandtab
set tabstop=4
set cursorline

" Keep working directory clean
set directory=~/.swp/,/tmp/
set backupdir=~/.backup/,/tmp/
set undodir=~/.undo/,/tmp/
