" Copyright 2022 The Wa Authors. All rights reserved.
"
" indent/wa.vim: Vim indent file for Wa.
"
" TODO:
" - function invocations split across lines
" - general line splits (line ends in an operator)

if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

" C indentation is too far off useful, mainly due to Wa's := operator.
" Let's just define our own.
setlocal nolisp
setlocal autoindent
setlocal indentexpr=WaIndent(v:lnum)
setlocal indentkeys+=<:>,0=},0=)

if exists("*WaIndent")
  finish
endif

function! WaIndent(lnum)
  let prevlnum = prevnonblank(a:lnum-1)
  if prevlnum == 0
    " top of file
    return 0
  endif

  " grab the previous and current line, stripping comments.
  let prevl = substitute(getline(prevlnum), '//.*$', '', '')
  let thisl = substitute(getline(a:lnum), '//.*$', '', '')
  let previ = indent(prevlnum)

  let ind = previ

  if prevl =~ '[({]\s*$'
    " previous line opened a block
    let ind += &sw
  endif
  if prevl =~# '^\s*\(case .*\|default\):$'
    " previous line is part of a switch statement
    let ind += &sw
  endif
  " TODO: handle if the previous line is a label.

  if thisl =~ '^\s*[)}]'
    " this line closed a block
    let ind -= &sw
  endif

  " Colons are tricky.
  " We want to outdent if it's part of a switch ("case foo:" or "default:").
  " We ignore trying to deal with jump labels because (a) they're rare, and
  " (b) they're hard to disambiguate from a composite literal key.
  if thisl =~# '^\s*\(case .*\|default\):$'
    let ind -= &sw
  endif

  return ind
endfunction
