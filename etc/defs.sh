#!/bin/bash

die() {
    >&2 echo -e "\x1B[31mError: $1\x1B[0m"
    if [[ $# -eq 1 ]]; then
        exit 1
    else
        exit $2
    fi
}

[[ -n "$PROJ_BASE" ]] || die "project environment not configured"

export PROJ_BIN=$PROJ_BASE/sbin

[[ -d $PROJ_BASE ]] || die "projects folder not found: $PROJ_BASE"
[[ -d $PROJ_BIN ]] || die "projects binary folder not found: $PROJ_BIN"
