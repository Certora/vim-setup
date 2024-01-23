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
syntax keyword cvlOnlyType method calldataarg env mathint
syntax keyword cvlTypedef ghost sort persistent

syntax keyword cvlStatement rule function definition invariant hook nextgroup=cvlFunction
syntax keyword cvlStatement methods preserved
syntax keyword cvlLabel envfree override
syntax keyword cvlKeyword require returns return forall havoc requireInvariant
syntax keyword cvlKeyword external internal expect
syntax keyword cvlKeyword with if else filtered at
syntax keyword cvlKeyword axiom init_state assuming
syntax keyword cvlKeyword builtin
syntax keyword cvlInclude using as import use
syntax keyword cvlException assert satisfy
syntax keyword cvlConstant true false
syntax keyword cvlConstant currentContract lastReverted lastStorage calledContract nativeBalances
syntax keyword cvlStorageClass STORAGE KEY INDEX memory calldata storage
syntax keyword cvlSummary ALWAYS CONSTANT PER_CALLEE_CONSTANT NONDET HAVOC_ECF HAVOC_ALL
syntax keyword cvlSummary DISPATCHER AUTO
syntax keyword cvlSummaryCondition ALL UNRESOLVED

" Address constants
syntax match cvlTypeConst "max_address"

" Explicit type casting
syntax keyword cvlCasting to_uint256 to_int256 to_mathint

" Recognize TODO inside comment - will be recognized only if contained
syntax keyword cvlTodo TODO FIXME NOTE CHECK contained


" Matches
" -------
" See :h pattern-overview for patterns

syntax match cvlNumber "\v<\d+>"

syntax match cvlFunction "\s*\<\h[a-zA-Z0-9_.]*" contained

syntax match cvlSolType "\<int\d*\>\|\<uint\d*\>\|\<bytes\d*\>"

syntax match cvlPreProc "@withrevert\>\|@norevert\>\|@new\>\|@old\>"

syntax match cvlCasting "\<to_bytes\d*\>"

syntax match cvlSignature "sig:" nextgroup=cvlFunction

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

" Integer constants
syntax match cvlTypeConst "max_u\{,1}int\d*"

" CVL2 type casting
syntax match cvlRequireCast "require_uint\d*"
syntax match cvlRequireCast "require_int\d*"
syntax match cvlAssertCast "assert_uint\d*"
syntax match cvlAssertCast "assert_int\d*"



" Regions
" -------
" String
syntax region cvlString start=/"/ end=/"/

" Mapping
syntax region cvlMappingDef start="(" end=")" contained contains=cvlMappingOperator,cvlSolType,cvlOnlyType

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
highlight default link cvlInclude Include
highlight default link cvlLabel Label
highlight default link cvlSummary Operator
highlight default link cvlSummaryCondition Conditional
highlight default link cvlException Exception
highlight default link cvlAssertCast Exception
highlight default link cvlRequireCast Keyword
highlight default link cvlTodo Todo
highlight default link cvlNumber Number
highlight default link cvlFunction Function
highlight default link cvlString String
highlight default link cvlConstant Constant
highlight default link cvlPreProc PreProc
highlight default link cvlStorageClass StorageClass
highlight default link cvlCasting Constant
highlight default link cvlTypeConst Constant
highlight default link cvlSignature Operator

" Comments
highlight default link cvlComment Comment
highlight default link cvlCommentVerbatim Comment

" CVLDoc
highlight default link cvlDoc Comment
highlight default link cvlDocTag Tag
highlight default link cvlDocParam Identifier

" Using markdown highlighting for other CVLDoc elements
highlight default link cvlDocTitle markdownH3
highlight default link cvlDocCode markdownCode
highlight default link cvlDocEmph markdownItalic

" syntax sync fromstart
