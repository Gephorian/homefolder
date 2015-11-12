if [ -d ~/.bashrc.d ]; then
  for file in ~/.bashrc.d/* ; do
	  . $file
  done
fi

# Show current git branch
alias ll='ls -lG --color=auto'
__git_ps1(){
__BRANCH=$(git branch 2>/dev/null | grep ^\* | perl -p -e 's/^\*\s+//g')
[[ -n "$__BRANCH" && "$__BRANCH" == 'master' ]] && echo -e "$__BRANCH"
[[ -n "$__BRANCH" && "$__BRANCH" != 'master' ]] && echo -e "$__BRANCH"
}

# Custom prompt (with colors!)
PS1="\[\033[32m\]\u@\h:\[\033[34m\]\w:\[\033[31m\]\[\033[31m\]\$(__git_ps1)\[\033[34m\]\$\[\033[00m\] "

# Ansible stuff
export ANSIBLE_HOST_KEY_CHECKING=False
export EDITOR=vim

# History control
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTRL=ignoreboth
shopt -s histappend

# Start tmux
[[ $- == *i* ]] && [[ -z "$TMUX" ]] && exec tmux
