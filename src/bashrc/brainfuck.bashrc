#!/bin/bash

export PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)/bin:$PATH"

function _brainfuck.bash_complete
{
    declare -r word="${COMP_WORDS[${COMP_CWORD}]}"

    case "${COMP_WORDS[1]}" in
        generate)
            if [[ ${COMP_CWORD} -le 2 ]]; then
                COMPREPLY=($(compgen -W '-0 -1 --generator1 -2 --generator2 -3 --generator3 -4 --generator4 -s --shortest-codes' -- "${word}"))
            fi
            ;;
        minify)
            # no-operation
            ;;
        *)
            COMPREPLY=($(compgen -W '-h --help generate minify' -- "${word}"))
            ;;
    esac
}

complete -o default -F _brainfuck.bash_complete brainfuck

