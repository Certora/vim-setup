" Vim file for adding Certora Vrification Language (CVL) linting to ALE plugin
function! CVLLintCallback(buffer, lines)
    let ret = []
    for line in a:lines
        let splitted = split(line, ":")
        let lnum = str2nr(splitted[0])
        let column = str2nr(splitted[1])
        let text = splitted[2]
        call add(ret, {"lnum": lnum, "col": column, "text": text})
    endfor

    return ret
endfunction

" TODO: Fix fake 'executable', improve 'command'
call ale#linter#Define('cvl', {
\    'name': 'cvl_lint',
\    'callback': "CVLLintCallback",
\    'command': 'python3 ~/.vim/after/ale_linters/cvl/cvl_lint.py --spec-path %s',
\    'executable': 'python3',
\})
