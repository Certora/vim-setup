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
syntax keyword cvlSolType address bool string
syntax keyword cvlSolType mapping nextgroup=cvlMappingDef

" Types unique to CVL
syntax keyword cvlOnlyType method calldataarg env mathint storage
syntax keyword cvlTypedef ghost sort

syntax keyword cvlStatement rule function definition invariant hook nextgroup=cvlFunction
syntax keyword cvlStatement methods preserved
syntax keyword cvlLabel envfree override
syntax keyword cvlKeyword require returns return forall havoc requireInvariant
syntax keyword cvlKeyword with if else using as filtered import at
syntax keyword cvlKeyword axiom init_state assuming
syntax keyword cvlException assert
syntax keyword cvlConstant true false
syntax keyword cvlConstant currentContract lastReverted lastStorage
syntax keyword cvlStorageClass STORAGE KEY

" Explicit type casting
syntax keyword cvlCasting to_uint256 to_int256 to_mathint

" Recognize TODO inside comment - will be recognized only if contained
syntax keyword cvlTodo TODO FIXME NOTE contained


" Matches
" -------
syntax match cvlNumber "\v<\d+>"

syntax match cvlFunction " \+\w\+" contained

syntax match cvlSolType "\<int\w*\|uint\w*\|bytes\w*"

syntax match cvlPreProc "@withrevert\|@norevert\|@new\|@old"

" Recognize => as mapping operator
syntax match cvlMappingOperator "=>" contained

" Spell check inside comments except between single quotation marks ``
syntax match cvlComment "//.*" contains=@Spell,cvlTodo,cvlCommentVerbatim

" NatSpec is the documentation standard for solidity, adopted in CVL
syntax match cvlNatSpec "///.*" contains=@Spell,cvlTodo,cvlCommentVerbatim,cvlNatSpecTag

" NatSpec tags
" TODO: Better recognition of these tags
syntax match cvlNatSpecTag "@title\|@author\|@notice\|@dev\|@param\|@return" contained


" Regions
" -------
" String
syntax region cvlString start=/"/ end=/"/

" Mapping
syntax region cvlMappingDef start="(" end=")" contained contains=cvlMappingOperator,cvlSolType

" Comment-block
syntax region cvlComment start="/\*" end="\*/" contains=@Spell,cvlTodo,cvlCommentVerbatim

" NatSpec-block
syntax region cvlNatSpec start="/\*\*" end="\*/" contains=@Spell,cvlTodo,cvlCommentVerbatim,cvlNatSpecTag

" Defined last to have priority
syntax match cvlCommentVerbatim "`.*`" contains=@NoSpell


" Syntax highlighting
" -------------------
" Set as known groups.
highlight default link cvlSolType Type
highlight default link cvlOnlyType Type
highlight default link cvlMappingOperator Type
highlight default link cvlTypedef Typedef
highlight default link cvlStatement Statement
highlight default link cvlKeyword Keyword
highlight default link cvlLabel Label
highlight default link cvlException Exception
highlight default link cvlTodo Todo
highlight default link cvlNumber Number
highlight default link cvlFunction Function
highlight default link cvlComment Comment
highlight default link cvlNatSpec Comment
highlight default link cvlNatSpecTag Tag
highlight default link cvlCommentVerbatim Comment
highlight default link cvlString String
highlight default link cvlConstant Constant
highlight default link cvlPreProc PreProc
highlight default link cvlStorageClass StorageClass
highlight default link cvlCasting Constant
