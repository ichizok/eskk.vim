" vim:foldmethod=marker:fen:
scriptencoding utf-8

" See 'plugin/skk7.vim' about the license.

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


" Functions {{{

func! skk7#util#warn(msg) "{{{
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunc "}}}

func! skk7#util#warnf(msg, ...) "{{{
    call skk7#util#warn(call('printf', [a:msg] + a:000))
endfunc "}}}

func! skk7#util#log(...) "{{{
    if g:skk7_debug
        return call('skk7#debug#log', a:000)
    endif
endfunc "}}}

func! skk7#util#logf(...) "{{{
    if g:skk7_debug
        return call('skk7#debug#logf', a:000)
    endif
endfunc "}}}

func! skk7#util#internal_error(...) "{{{
    if a:0 == 0
        call skk7#util#warn('skk7: util: sorry, internal error.')
    else
        call skk7#util#warn('skk7: util: sorry, internal error: ' . a:1)
    endif
endfunc "}}}


func! skk7#util#mb_strlen(str) "{{{
    return strlen(substitute(copy(a:str), '.', 'x', 'g'))
endfunc "}}}

func! skk7#util#mb_chop(str) "{{{
    return substitute(a:str, '.$', '', '')
endfunc "}}}


func! skk7#util#get_args(args, ...) "{{{
    let ret_args = []
    let i = 0

    while i < len(a:000)
        call add(
        \   ret_args,
        \   skk7#util#has_idx(a:args, i) ?
        \       a:args[i]
        \       : a:000[i]
        \)
        let i += 1
    endwhile

    return ret_args
endfunc "}}}

" NOTE: Not supported negative idx.
func! skk7#util#has_idx(list, idx) "{{{
    return 0 < a:idx && a:idx < len(a:list)
endfunc "}}}

" a:func is string.
"
" NOTE: This returns 0 for script local function.
func! skk7#util#is_callable(Fn) "{{{
    return type(a:Fn) == type(function('tr'))
    \   || exists('*' . a:Fn)
endfunc "}}}

" arg 3 is not for 'self'.
func! skk7#util#call_if_exists(Fn, args, ...) "{{{
    if skk7#util#is_callable(a:Fn)
        return call(a:Fn, a:args)
    elseif a:0 != 0
        return a:1
    else
        throw printf("skk7: no such function '%s'.", a:Fn)
    endif
endfunc "}}}

func! skk7#util#exists_func(Fn) "{{{
    try
        call skk7#util#call_if_exists(a:Fn, [])
        return 1
    catch /^E117:/    " 未知の関数です
        return 0
    catch /^skk7: no such function/
        return 0
    catch /^\(Vim(return):\)\=E119:/    " 関数の引数が少な過ぎます
        return 1
    endtry
endfunc "}}}


" For macro. {{{

func! skk7#util#skip_spaces(str) "{{{
    return substitute(a:str, '^\s*', '', '')
endfunc "}}}

" TODO Escape + Whitespace
func! skk7#util#get_arg(arg) "{{{
    let matched = matchstr(a:arg, '^\S\+')
    return [matched, strpart(a:arg, strlen(matched))]
endfunc "}}}

func! skk7#util#unget_arg(arg, str) "{{{
    return a:str . a:arg
endfunc "}}}

" }}}

" }}}


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}