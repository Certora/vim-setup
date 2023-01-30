" Certora Verification Language filetype plugin
" =============================================

setlocal spell spelllang=en_us  " Spell check (in comments only)

" ALE setup
" ---------
" Add cvl linter
source ~/.vim/after/ale_linters/cvl/cvl_lint.vim

" No fixers
let b:ale_fixers=[]
let b:fix_on_save=0

" lint on save only
let b:ale_lint_on_insert_leave = 0
let b:ale_lint_on_text_changed = 0

" Indentation
" -----------
setlocal autoindent
setlocal smartindent  " Provides C-style indentation

" Tab
" ---
set tabstop=4
set softtabstop=4
set shiftwidth=4
" set expandtab - disabled since people use tabs :(
set fileformat=unix
