" syntax for Certora Verification Language (CVL)
" ==============================================
" See
" :h syntax
" :h group-name (for naming conventions)
"
" NOTE: priority rules
"
" SEE: For CVLDoc (cvlDoc and cvlDocTag) see
" https://certora.atlassian.net/wiki/spaces/PROD/pages/308838729/CVLDoc+comments
" Since CVLDoc should support Markdown, we use markdown highlighting inside
" cvlDoc. Note that CVLDoc is built to be similar to solidity's NatSpec.

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
" See :h pattern-overview for patterns

syntax match cvlNumber "\v<\d+>"

syntax match cvlFunction "\s\+\w\+" contained

syntax match cvlSolType "\<int\w*\|uint\w*\|bytes\w*"

syntax match cvlPreProc "@withrevert\>\|@norevert\>\|@new\>\|@old\>"

" Recognize => as mapping operator
syntax match cvlMappingOperator "=>" contained

" Spell check inside comments except between single quotation marks ``
syntax match cvlComment "//.*" contains=@Spell,cvlTodo,cvlCommentVerbatim

" CVLDoc
syntax match cvlDoc "///.*" contains=@Spell,cvlTodo,cvlDocCode,cvlDocTag,cvlDocEmph

" CVLDoc emphasis
" syntax match cvlDocEmph "\*\S.*\S\*" contained

" CVLDoc tags
syntax match cvlDocTag "@notice\>\|@dev\>\|@return\>\|@formula\>" contained

syntax match cvlDocTag "@title\ze\s" contained nextgroup=cvlDocTitle
syntax match cvlDocTitle "\s.*$" contained

syntax match cvlDocTag "@param\ze\s" contained nextgroup=cvlDocParam
syntax match cvlDocParam "\s\w\+" contained contains=@NoSpell



" Regions
" -------
" String
syntax region cvlString start=/"/ end=/"/

" Mapping
syntax region cvlMappingDef start="(" end=")" contained contains=cvlMappingOperator,cvlSolType

" Comment-block
syntax region cvlComment start="/\*" end="\*/" contains=@Spell,cvlTodo,cvlCommentVerbatim

" CVLDoc-block
syntax region cvlDoc start="/\*\*" end="\*/" contains=@Spell,cvlTodo,cvlDocCode,cvlDocTag,cvlDocEmph

" CVLDoc code
syntax region cvlDocCode start=/`/ end=/`/ contained contains=@NoSpell

" Defined last to have priority
" -----------------------------
syntax match cvlCommentVerbatim "`.*`" contained contains=@NoSpell


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
highlight default link cvlString String
highlight default link cvlConstant Constant
highlight default link cvlPreProc PreProc
highlight default link cvlStorageClass StorageClass
highlight default link cvlCasting Constant

" Comments
highlight default link cvlComment Comment
highlight default link cvlCommentVerbatim Comment

" CVLDoc
highlight default link cvlDoc Comment
highlight default link cvlDocTag Tag
highlight default link cvlDocParam Identifier

" Using markdown highlighting for other CVLDoc elements
highlight default link cvlDocTitle markdownH2
highlight default link cvlDocCode markdownCode
highlight default link cvlDocEmph markdownItalic
