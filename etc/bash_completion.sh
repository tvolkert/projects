__proj_main ()
{
    projects="$($PROJ_BASE/sbin/get_all)" || return 0
    COMPREPLY=( $(compgen -W "${projects}" -- ${COMP_WORDS[COMP_CWORD]}) )
    return 0
}

complete -F __proj_main proj
