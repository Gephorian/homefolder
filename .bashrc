if [ -d ~/.bashrc.d ]; then
  for file in ~/.bashrc.d/* ; do
	  . $file
  done
fi

alias ll='ls -lG --color=auto'

# Show current git branch
__git_ps1(){
  __GIT=$(git status 2>/dev/null)
  __BRANCH=$(echo -e $__GIT | grep -e 'HEAD detached at' -e 'On branch' | perl -p -e 's/(On branch |HEAD detached at )(.*?)\s.*/$2/')
  [[ -n "$__BRANCH" ]] || return 0
  [[ "$__BRANCH" == 'master' ]] && echo -en ":$__BRANCH" || echo -en ":$__BRANCH"
  if ! echo $__GIT | grep 'working directory clean' 2>/dev/null >/dev/null; then
    echo -en "*"
  fi
}

PS1="\[\e[0;49;32m\]\u@\h:\[\e[34m\]\w\\[\e[31m\]\$(__git_ps1)\[\e[0m\e[0;49;34m\]\$\[\e[00m\] "

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

