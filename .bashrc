__proj_die() {
    >&2 echo -e "\x1B[31mError: $1\x1B[0m"
    unset PROJ_BASE
    unset proj
    unset cdp
    return 1
}

proj() {
    if [ $# -gt 1 ]; then
        read -r -d '' usage << EOM
usage: proj [<project-name>]

- With no arguments, prints the list of valid
  projects, highlighting the current project.

- With a valid project name as the sole argument,
  sets the current project.
EOM
        >&2 echo "$usage"
        return 1
    elif [[ $# -eq 0 ]]; then
        $PROJ_BASE/sbin/list
    elif [[ $# -eq 1 ]]; then
        $PROJ_BASE/sbin/set_current $1 || return 1
        export PROJ_CURRENT=$1
        export PATH="$PROJ_BASE/all/$PROJ_CURRENT/bin:$PATH"
    fi
}

cdp() {
    [[ -n "$PROJ_BASE" ]] || return $(__proj_die "project environment not configured")
    local proj=$($PROJ_BASE/sbin/get_current) || return $(__proj_die "could not get current project")
    local home_symlink=$PROJ_BASE/all/$proj/home
    [[ -h $home_symlink ]] || return $(__proj_die "home link missing for project: $proj")
    cd $(readlink $home_symlink)&>/dev/null || return $(__proj_die "could not cd to project home")
}

export PROJ_BASE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
export PROJ_CURRENT=$($PROJ_BASE/sbin/get_current) || __proj_die "could not get current project"
export PATH="$PROJ_BASE/all/$PROJ_CURRENT/bin:$PATH"
