#!/bin/bash

. $PROJ_BASE/etc/defs.sh || exit 1

$PROJ_BIN/update_current_if_needed || exit $?
export CURRENT=$($PROJ_BIN/get_current) || die "could not get current project"
cd $PROJ_BASE/all/$CURRENT/home || die "could not open project home"
