GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true

function __prompt_command() {
    local rc="$?"
    exit=""

    __git_ps1 "\[\033[0;36m\]\W\[\033[0m\]" " \$\[\033[0m\] " " · %s"
}
