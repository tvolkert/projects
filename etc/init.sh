#!/bin/bash

. $PROJ_BASE/etc/defs.sh || exit 1

$PROJ_BIN/update_current_if_needed || exit $?
export CURRENT=$($PROJ_BIN/get_current) || die "could not get current project"
[[ -n "$CURRENT" ]] || die "current project is unset"
home_symlink=$PROJ_BASE/all/$CURRENT/home
[[ -h $home_symlink ]] || die "home symlink missing for project: ~$CURRENT/home"
cd $home_symlink&>/dev/null || die "could not open project home"
