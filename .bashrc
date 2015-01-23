#[[ $- != *i* ]] && return
#[[ -z "$TMUX" ]] && exec tmux

source .bashrc.d/*

export ANSIBLE_HOST_KEY_CHECKING=False

alias ll='ls -lG'
__git_ps1(){
__BRANCH=$(git branch 2>/dev/null | grep ^\* | awk '{ print $2 }')
[[ -n "$__BRANCH" && "$__BRANCH" == 'master' ]] && echo -e "$__BRANCH"
[[ -n "$__BRANCH" && "$__BRANCH" != 'master' ]] && echo -e "$__BRANCH"
}
PS1="\[\033[32m\]\u@\h:\[\033[34m\]\w:\[\033[31m\]\[\033[31m\]\$(__git_ps1)\[\033[34m\]\$\[\033[00m\] "
