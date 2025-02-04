#!/usr/bin/env bash

set -eu -o posix -o pipefail

declare -gr ROOT_DIR="$(cd -- "$(dirname -- "$0")/../.." && pwd)"

for i in $(seq 4)
do
    echo "==== generator${i}"
    echo -ne 'Hello, World!\r\n' | ${ROOT_DIR}/bin/brainfuck generate -${i}
    echo
done

