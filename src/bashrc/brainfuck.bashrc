#!/bin/bash

export PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)/bin:$PATH"

function _brainfuck.bash_complete
{
    declare -r word="${COMP_WORDS[${COMP_CWORD}]}"

    case "${COMP_WORDS[1]}" in
        build-string-generator)
            # no-operation
            ;;
        output-string-generator)
            if [[ ${COMP_CWORD} -le 2 ]]; then
                COMPREPLY=($(compgen -W '-a --algorithm-all -1 --algorithm-1 -2 --algorithm-2 -3 --algorithm-3 -4 --algorithm-4' -- "${word}"))
            fi
            ;;
        code-map-generator)
            # no-operation
            ;;
        minify)
            # no-operation
            ;;
        *)
            COMPREPLY=($(compgen -W '-h --help build-string-generator output-string-generator code-map-generator minify' -- "${word}"))
            ;;
    esac
}

complete -o default -F _brainfuck.bash_complete brainfuck

