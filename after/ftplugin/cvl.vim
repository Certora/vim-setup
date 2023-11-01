" Certora Verification Language filetype plugin
" =============================================

setlocal spell spelllang=en_us  " Spell check (in comments only)


" Indentation
" -----------
setlocal autoindent
setlocal smartindent  " Provides C-style indentation

" Tab
" ---
set tabstop=4
set softtabstop=4
set shiftwidth=4
" set expandtab - note some people use tabs :(
set expandtab
set fileformat=unix

" UI Config
" ---------
" A marked column to prevent going too far, color defined below 
setlocal colorcolumn=90
highlight ColorColumn ctermbg=235
