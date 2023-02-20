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
syntax keyword cvlTypedef ghost sort

syntax keyword cvlStatement rule function definition invariant hook nextgroup=cvlFunction
syntax keyword cvlStatement methods preserved
syntax keyword cvlLabel envfree override
syntax keyword cvlKeyword require returns return forall havoc requireInvariant with if using as filtered import
syntax keyword cvlKeyword axiom init_state assuming
syntax keyword cvlException assert
syntax keyword cvlConstant true false
syntax keyword cvlConstant currentContract lastReverted
syntax keyword cvlStorageClass STORAGE KEY

" Recognize TODO inside comment - will be recognized only if contained
syntax keyword cvlTodo TODO FIXME NOTE contained


" Matches
" ------
syntax match cvlNumber "\v<\d+>"

syntax match cvlFunction " \+\w\+" contained

syntax match cvlSolType "\<int\w*\|uint\w*\|bytes\w*"

syntax match cvlComment "//.*" contains=@Spell,cvlTodo

syntax match cvlPreProc "@withrevert\|@norevert\|@new\|@old"


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
highlight default link cvlTypedef Typedef
highlight default link cvlStatement Statement
highlight default link cvlKeyword Keyword
highlight default link cvlLabel Label
highlight default link cvlException Exception
highlight default link cvlTodo Todo
highlight default link cvlNumber Number
highlight default link cvlFunction Function
highlight default link cvlComment Comment
highlight default link cvlString String
highlight default link cvlConstant Constant
highlight default link cvlPreProc PreProc
highlight default link cvlStorageClass StorageClass
