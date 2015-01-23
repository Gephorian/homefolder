#[[ $- != *i* ]] && return
#[[ -z "$TMUX" ]] && exec tmux

export AWS_ACCESS_KEY_ID=AKIAJ75VQH6X6QU5TPBA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-east-1
export EC2_INI_PATH=~/ec2.ini

export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/acoleman/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

export IRCNICK=gephorian
export IRCNAME=gephorian
export IRCSERVER=irc.drunkserver.com
export IRCSERVERSFILE=/Users/acoleman/.ircservers

export ANSIBLE_HOST_KEY_CHECKING=False

alias ll='ls -lG'
__git_ps1(){
__BRANCH=$(git branch 2>/dev/null | grep ^\* | awk '{ print $2 }')
[[ -n "$__BRANCH" && "$__BRANCH" == 'master' ]] && echo -e "$__BRANCH"
[[ -n "$__BRANCH" && "$__BRANCH" != 'master' ]] && echo -e "$__BRANCH"
}
PS1="\[\033[32m\]\u@\h:\[\033[34m\]\w:\[\033[31m\]\[\033[31m\]\$(__git_ps1)\[\033[34m\]\$\[\033[00m\] "
