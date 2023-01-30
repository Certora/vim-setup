" syntax for Certora Verification Language (CVL)
" ==============================================
" See
" :h syntax
" :h group-name (for naming conventions)
"
" NOTE: priority rules

" Do nothing if syntax already defined for this buffer
if exists("b:current_syntax")
  finish
endif

" Keywords
" --------

" Types that exist in solidity
syntax keyword cvlSolType address bool strings
" Types unique to CVL
syntax keyword cvlOnlyType method calldataarg env mathint storage

syntax keyword cvlStatement rule function definition nextgroup=cvlFunction
syntax keyword cvlStatement methods
syntax keyword cvlLabel envfree override
syntax keyword cvlKeyword require returns
syntax keyword cvlException assert

" Recognize TODO inside comment - will be recognized only if contained
syntax keyword cvlTodo TODO contained


" Matches
" ------
syntax match cvlNumber "\v<\d+>"

syntax match cvlFunction " \+\w\+" contained

syntax match cvlSolType "int\w*\|uint\w*\|bytes\w*"

syntax match cvlComment "//.*" contains=@Spell,cvlTodo


" Regions
" -------
syntax region cvlString start=/"/ end=/"/

" comment-block
syntax region cvlComment start="/\*" end="\*/" contains=@Spell,cvlTodo


" Syntax highlighting
" -------------------
" Set as known groups.
highlight default link cvlSolType Type
highlight default link cvlOnlyType Type
highlight default link cvlStatement Statement
highlight default link cvlKeyword Keyword
highlight default link cvlLabel Label
highlight default link cvlException Exception
highlight default link cvlTodo Todo
highlight default link cvlNumber Number
highlight default link cvlFunction Function
highlight default link cvlComment Comment
highlight default link cvlString String
