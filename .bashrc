if [ -d ~/.bashrc.d ]; then
  for file in ~/.bashrc.d/* ; do
	  . $file
  done
fi

alias ll='ls -lG'

# Show current git branch
__git_ps1(){
  __GIT=$(git status 2>/dev/null)
  __BRANCH=$(echo -e $__GIT | grep -e 'HEAD detached at' -e 'On branch' | perl -p -e 's/^.*?(On branch |HEAD detached at )(.*?)\s.*/$2/')
  [[ -n "$__BRANCH" ]] || return 0
  [[ "$__BRANCH" == 'master' ]] && echo -en " ($__BRANCH)" || echo -en " ($__BRANCH)"
  if ! echo $__GIT | grep -E 'working (directory|tree) clean' 2>/dev/null >/dev/null; then
    echo -en "*"
  fi
}

# tmux themes must be set in .tmux.conf
case "$__THEME" in
  purple)
    PS1="\[\e[1;49;95m\][\[\e[1;49;97m\]\u\[\e[1;49;95m\]@\[\e[1;49;97m\]\h\[\e[1;49;95m\]]\[\e[1;49;97m\]\w\\[\e[31m\]\$(__git_ps1)\[\e[0m\e[1;49;95m\]$\[\e[00m\] "
# Status Bar
    export __TMUXBG=colour53
    export __TMUXFG=colour8
# Select Window
    export __TMUX_MODE_BG=colour53
    export __TMUX_MODE_FG=colour8
# Pane Select
    export __TMUX_PANE=colour8
    export __TMUX_ACTIVE_PANE=colour53
    export __TMUX_PANE_BORDER=black
    export __TMUX_ACTIVE_PANE_BORDER=colour53
  ;;
  purple-extended)
    PS1="\[\e[1;49;95m\][\[\e[1;49;97m\]\u\[\e[1;49;95m\]@\[\e[1;49;97m\]\h\[\e[1;49;95m\]]\[\e[1;49;97m\]\w\\[\e[31m\]\$(__git_ps1)
\[\e[0m\e[1;49;95m\]>>>\[\e[00m\] "
    export __TMUXBG=colour53
    export __TMUXFG=colour8
    export __TMUX_MODE_BG=colour53
    export __TMUX_MODE_FG=colour8
    export __TMUX_PANE=colour8
    export __TMUX_ACTIVE_PANE=colour53
    export __TMUX_PANE_BORDER=black
    export __TMUX_ACTIVE_PANE_BORDER=colour53
  ;;
  white)
    PS1="\[\e[1;49;97m\][\u@\h]\w\$(__git_ps1)$\[\e[00m\] "
    export __TMUXBG=white
    export __TMUXFG=black
    export __TMUX_MODE_BG=white
    export __TMUX_MODE_FG=black
    export __TMUX_PANE=black
    export __TMUX_ACTIVE_PANE=white
    export __TMUX_PANE_BORDER=black
    export __TMUX_ACTIVE_PANE_BORDER=white
  ;;
  white-extended)
    PS1="\[\e[1;49;97m\][\u@\h]\w\$(__git_ps1)
>>>\[\e[00m\] "
    export __TMUXBG=white
    export __TMUXFG=black
    export __TMUX_MODE_BG=white
    export __TMUX_MODE_FG=black
    export __TMUX_PANE=black
    export __TMUX_ACTIVE_PANE=white
    export __TMUX_PANE_BORDER=black
    export __TMUX_ACTIVE_PANE_BORDER=white
  ;;
  green-extended)
    PS1="\[\e[1;49;32m\][\[\e[34m\]\u\[\e[31m\]@\[\e[34m\]\h\[\e[1;49;32m\]]\[\e[0;49;32m\]\w\\[\e[31m\]\$(__git_ps1)
\[\e[0m\e[1;49;32m\]>>>\[\e[00m\] "
    export __TMUXBG=green
    export __TMUXFG=black
    export __TMUX_MODE_BG=yellow
    export __TMUX_MODE_FG=black
    export __TMUX_PANE=blue
    export __TMUX_ACTIVE_PANE=red
    export __TMUX_PANE_BORDER=white
    export __TMUX_ACTIVE_PANE_BORDER=green
  ;;
  *)
    PS1="\[\e[0;49;32m\]\u@\h:\[\e[34m\]\w\\[\e[31m\]\$(__git_ps1)\[\e[0m\e[0;49;34m\]\$\[\e[00m\] "
    export __TMUXBG=green
    export __TMUXFG=black
    export __TMUX_MODE_BG=yellow
    export __TMUX_MODE_FG=black
    export __TMUX_PANE=blue
    export __TMUX_ACTIVE_PANE=red
    export __TMUX_PANE_BORDER=white
    export __TMUX_ACTIVE_PANE_BORDER=green
  ;;
esac    

# Ansible stuff
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_NOCOWS=1
export EDITOR=vim

# History control
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTRL=ignoreboth
shopt -s histappend

PATH="/home/adam/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/adam/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/adam/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/adam/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/adam/perl5"; export PERL_MM_OPT;

# Useful subroutines
showcolors(){
for clbg in {40..47} {100..107} 49 ; do
	#Foreground
	for clfg in {30..37} {90..97} 39 ; do
		#Formatting
		for attr in 0 1 2 4 5 7 ; do
			#Print the result
			echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
		done
		echo #Newline
	done
done
} 

# Start tmux
[[ $- == *i* ]] && [[ -z "$TMUX" ]] && exec tmux

