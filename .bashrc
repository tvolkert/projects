export PROJ_BASE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

__proj_die() {
    >&2 echo -e "\x1B[31mError: $1\x1B[0m"
    unset PROJ_BASE
    unset proj
    unset cdp
    return 1
}

__proj_list() {
    echo "Projects:"
    for project in "${projects[@]}"; do
        printf " - "
        if [[ "$project" == "$current" ]]; then
            printf "\x1B[92m%s\x1B[0m" $project
        else
            printf "%s" $project
        fi
        home_symlink=$PROJ_BASE/all/$project/home
        if [[ -h $home_symlink ]]; then
            printf " --> %s" $(readlink $home_symlink)
        fi
        printf "\n"
    done
    echo ""
}

proj() {
    if [ $# -gt 1 ]; then
        read -r -d '' usage << EOM
usage: $(basename $0) [<project-name>]

- With no arguments, prints the list of valid
  projects, highlighting the current project.

- With a valid project name as the sole argument,
  sets the current project.
EOM
        >&2 echo $usage
        return 1
    fi

    local projects=( $($PROJ_BASE/sbin/get_all) ) || return $(__proj_die "could not list projects")
    local current=$($PROJ_BASE/sbin/get_current) || return $(__proj_die "could not get current project")
    [[ "${#projects[@]}" -gt 0 ]] || return $(__proj_die "no projects have been configured")

    if [[ $# -eq 0 ]]; then
        __proj_list
    elif [[ $# -eq 1 ]]; then
        $PROJ_BASE/sbin/set_current $1
    fi

    return 0
}

cdp() {
    [[ -n "$PROJ_BASE" ]] || return $(__proj_die "project environment not configured")
    local proj=$($PROJ_BASE/sbin/get_current) || return $(__proj_die "could not get current project")
    local home_symlink=$PROJ_BASE/all/$proj/home
    [[ -h $home_symlink ]] || return $(__proj_die "home link missing for project: $proj")
    cd $(readlink $home_symlink)&>/dev/null || return $(__proj_die "could not cd to project home")
}

[[ -d $PROJ_BASE ]] || __proj_die "projects folder not found: $PROJ_BASE"
[[ -d $PROJ_BASE/etc ]] || __proj_die "project system folder not found: $PROJ_BASE/etc"
[[ -d $PROJ_BASE/sbin ]] || __proj_die "project system folder not found: $PROJ_BASE/sbin"

export PATH="$PROJ_BASE/latest/bin:$PATH"
