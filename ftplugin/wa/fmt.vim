" Copyright 2022 The Wa Authors. All rights reserved.
"
" fmt.vim: Vim command to format Wa files with wa fmt.
"
" This filetype plugin add a new commands for wa buffers:
"
"   :Fmt
"
"       Filter the current Wa buffer through wa fmt.
"       It tries to preserve cursor position and avoids
"       replacing the buffer with stderr output.
"

command! -buffer Fmt call s:WaFormat()

function! s:WaFormat()
    let view = winsaveview()
    silent %!wa fmt
    if v:shell_error
        let errors = []
        for line in getline(1, line('$'))
            let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\(\d\+\)\s*\(.*\)')
            if !empty(tokens)
                call add(errors, {"filename": @%,
                                 \"lnum":     tokens[2],
                                 \"col":      tokens[3],
                                 \"text":     tokens[4]})
            endif
        endfor
        if empty(errors)
            % | " Couldn't detect 'wa fmt' error format, output errors
        endif
        undo
        if !empty(errors)
            call setloclist(0, errors, 'r')
        endif
        echohl Error | echomsg "wa fmt returned error" | echohl None
    endif
    call winrestview(view)
endfunction

" vim:ts=4:sw=4:et
