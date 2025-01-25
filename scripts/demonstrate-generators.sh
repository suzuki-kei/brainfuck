#!/usr/bin/env bash

set -eu -o posix -o pipefail

declare -gr ROOT_DIR="$(cd -- "$(dirname -- "$0")/.." && pwd)"

for i in $(seq 3)
do
    echo "==== generator${i}"
    echo -ne 'Hello, World!\r\n' | ${ROOT_DIR}/bin/brainfuck.generator${i}
    echo
done

