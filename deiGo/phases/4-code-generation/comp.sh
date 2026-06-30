#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 file1 file2"
    exit 1
fi

if [ ! -f "$1" ] || [ ! -f "$2" ]; then
    echo "Error: Both arguments must be valid files"
    exit 1
fi

diff --suppress-common-lines -y --width=200 "$1" "$2" | grep -n "^" | sed 's/:/\t/'

exit 0