" Copyright 2022 The Wa Authors. All rights reserved.
"
" wa.vim: Vim syntax file for Wa.
"
" Options:
"   There are some options for customizing the highlighting; the recommended
"   settings are the default values, but you can write:
"     let OPTION_NAME = 0
"   in your ~/.vimrc file to disable particular options. You can also write:
"     let OPTION_NAME = 1
"   to enable particular options. At present, all options default to on.
"
"   - wa_highlight_array_whitespace_error
"     Highlights white space after "[]".
"   - wa_highlight_chan_whitespace_error
"     Highlights white space around the communications operator that don't follow
"     the standard style.
"   - wa_highlight_extra_types
"     Highlights commonly used library types (io.Reader, etc.).
"   - wa_highlight_space_tab_error
"     Highlights instances of tabs following spaces.
"   - wa_highlight_trailing_whitespace_error
"     Highlights trailing white space.

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

if !exists("wa_highlight_array_whitespace_error")
  let wa_highlight_array_whitespace_error = 1
endif
if !exists("wa_highlight_chan_whitespace_error")
  let wa_highlight_chan_whitespace_error = 1
endif
if !exists("wa_highlight_extra_types")
  let wa_highlight_extra_types = 1
endif
if !exists("wa_highlight_space_tab_error")
  let wa_highlight_space_tab_error = 1
endif
if !exists("wa_highlight_trailing_whitespace_error")
  let wa_highlight_trailing_whitespace_error = 1
endif

syn case match

syn keyword     waDirective         import
syn keyword     waDeclaration       var const type
syn keyword     waDeclType          struct interface

hi def link     waDirective         Statement
hi def link     waDeclaration       Keyword
hi def link     waDeclType          Keyword

" Keywords within functions
syn keyword     waStatement         defer return break continue
syn keyword     waConditional       if else switch
syn keyword     waLabel             case default
syn keyword     waRepeat            for range

hi def link     waStatement         Statement
hi def link     waConditional       Conditional
hi def link     waLabel             Label
hi def link     waRepeat            Repeat

" Predefined types
syn keyword     waType              map bool string error
syn keyword     waSignedInts        int int8 int16 int32 int64 rune i8 i16 i32 i64
syn keyword     waUnsignedInts      byte uint uint8 uint16 uint32 uint64 uintptr u8 u16 u32 u64
syn keyword     waFloats            float32 float64 f32 f64
syn keyword     waComplexes         complex64 complex128

hi def link     waType              Type
hi def link     waSignedInts        Type
hi def link     waUnsignedInts      Type
hi def link     waFloats            Type
hi def link     waComplexes         Type

" Treat fn specially: it's a declaration at the start of a line, but a type
" elsewhere. Order matters here.
syn match       waType              /\<fn\>/
syn match       waDeclaration       /^fn\>/

" Predefined functions and values
syn keyword     waBuiltins          append cap close complex copy delete imag len
syn keyword     waBuiltins          make new panic print println real recover
syn keyword     waConstants         iota true false nil

hi def link     waBuiltins          Keyword
hi def link     waConstants         Keyword

" Comments; their contents
syn keyword     waTodo              contained TODO FIXME XXX BUG
syn cluster     waCommentGroup      contains=waTodo
syn region      waComment           start="/\*" end="\*/" contains=@waCommentGroup,@Spell
syn region      waComment           start="//" end="$" contains=@waCommentGroup,@Spell
syn region      waComment           start="#" end="$" contains=@waCommentGroup,@Spell

hi def link     waComment           Comment
hi def link     waTodo              Todo

" Wo escapes
syn match       waEscapeOctal       display contained "\\[0-7]\{3}"
syn match       waEscapeC           display contained +\\[abfnrtv\\'"]+
syn match       waEscapeX           display contained "\\x\x\{2}"
syn match       waEscapeU           display contained "\\u\x\{4}"
syn match       waEscapeBigU        display contained "\\U\x\{8}"
syn match       waEscapeError       display contained +\\[^0-7xuUabfnrtv\\'"]+

hi def link     waEscapeOctal       waSpecialString
hi def link     waEscapeC           waSpecialString
hi def link     waEscapeX           waSpecialString
hi def link     waEscapeU           waSpecialString
hi def link     waEscapeBigU        waSpecialString
hi def link     waSpecialString     Special
hi def link     waEscapeError       Error

" Strings and their contents
syn cluster     waStringGroup       contains=waEscapeOctal,waEscapeC,waEscapeX,waEscapeU,waEscapeBigU,waEscapeError
syn region      waString            start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@waStringGroup
syn region      waRawString         start=+`+ end=+`+

hi def link     waString            String
hi def link     waRawString         String

" Characters; their contents
syn cluster     waCharacterGroup    contains=waEscapeOctal,waEscapeC,waEscapeX,waEscapeU,waEscapeBigU
syn region      waCharacter         start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=@waCharacterGroup

hi def link     waCharacter         Character

" Regions
syn region      waBlock             start="{" end="}" transparent fold
syn region      waParen             start='(' end=')' transparent

" Integers
syn match       waDecimalInt        "\<\d\+\([Ee]\d\+\)\?\>"
syn match       waHexadecimalInt    "\<0x\x\+\>"
syn match       waOctalInt          "\<0\o\+\>"
syn match       waOctalError        "\<0\o*[89]\d*\>"

hi def link     waDecimalInt        Integer
hi def link     waHexadecimalInt    Integer
hi def link     waOctalInt          Integer
hi def link     Integer             Number

" Floating point
syn match       waFloat             "\<\d\+\.\d*\([Ee][-+]\d\+\)\?\>"
syn match       waFloat             "\<\.\d\+\([Ee][-+]\d\+\)\?\>"
syn match       waFloat             "\<\d\+[Ee][-+]\d\+\>"

hi def link     waFloat             Float

" Imaginary literals
syn match       waImaginary         "\<\d\+i\>"
syn match       waImaginary         "\<\d\+\.\d*\([Ee][-+]\d\+\)\?i\>"
syn match       waImaginary         "\<\.\d\+\([Ee][-+]\d\+\)\?i\>"
syn match       waImaginary         "\<\d\+[Ee][-+]\d\+i\>"

hi def link     waImaginary         Number

" Spaces after "[]"
if wa_highlight_array_whitespace_error != 0
  syn match waSpaceError display "\(\[\]\)\@<=\s\+"
endif

" Spacing errors around the 'chan' keyword
if wa_highlight_chan_whitespace_error != 0
  " receive-only annotation on chan type
  syn match waSpaceError display "\(<-\)\@<=\s\+\(chan\>\)\@="
  " send-only annotation on chan type
  syn match waSpaceError display "\(\<chan\)\@<=\s\+\(<-\)\@="
  " value-ignoring receives in a few contexts
  syn match waSpaceError display "\(\(^\|[={(,;]\)\s*<-\)\@<=\s\+"
endif

" Extra types commonly seen
if wa_highlight_extra_types != 0
  syn match waExtraType /\<bytes\.\(Buffer\)\>/
  syn match waExtraType /\<io\.\(Reader\|Writer\|ReadWriter\|ReadWriteCloser\)\>/
  syn match waExtraType /\<reflect\.\(Kind\|Type\|Value\)\>/
  syn match waExtraType /\<unsafe\.Pointer\>/
endif

" Space-tab error
if wa_highlight_space_tab_error != 0
  syn match waSpaceError display " \+\t"me=e-1
endif

" Trailing white space error
if wa_highlight_trailing_whitespace_error != 0
  syn match waSpaceError display excludenl "\s\+$"
endif

hi def link     waExtraType         Type
hi def link     waSpaceError        Error

" Search backwards for a global declaration to start processing the syntax.
"syn sync match waSync grouphere NONE /^\(const\|var\|type\|fn\)\>/

" There's a bug in the implementation of grouphere. For now, use the
" following as a more expensive/less precise workaround.
syn sync minlines=500

let b:current_syntax = "wa"
