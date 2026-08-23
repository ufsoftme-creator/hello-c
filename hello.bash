_hello_completion()
{
    local current_word="${COMP_WORDS[COMP_CWORD]}"
    local options="--help --version -h -v"

    COMPREPLY=($(compgen -W "$options" -- "$current_word"))
}

complete -F _hello_completion hello ./hello