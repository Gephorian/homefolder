" ALE https://github.com/dense-analysis/ale
map \ll :ALEFix<enter>
let g:ale_fix_on_save = 1
let g:ale_python_flake8_options = '--max-line-length=256'
let g:ale_python_pylint_options = '--disable=C0103'

" Colors
" autocmd ColorScheme * highlight ALEVirtualTextWarning ctermfg=orange
" autocmd ColorScheme * hi ALEVirtualTextError guifg=red
hi ALEVirtualTextError guifg=black guibg=white
hi ALEVirtualTextWarning guifg=black guibg=white
