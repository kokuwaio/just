#!/bin/sh
set -eu;

FILES=$(find "$(pwd)" -type f \( -name '.justfile' -o -name 'justfile' \) -not -path '*/node_modules/*')
if [ ! "$FILES" ]; then
	echo "No files found!"
	exit 1
fi
for FILE in ${FILES}; do
    COMMAND="just --unstable --fmt --check --color=always --justfile=$FILE"
    echo "$COMMAND"
    eval "$COMMAND"
done
