" File type detection for CVL = Certora Verification Language
" Aka EVM Spec, CVL, Certora Verification language *.spec, *.cvl
autocmd BufRead,BufNewFile *.spec,*.cvl set filetype=cvl

" Improve comment syntax highlighting (avoid missing comment region)
" see :help :syn-sync-ccomment
 autocmd BufReadPost,BufNewFile *.spec,*.cvl syntax sync ccomment cvlComment
