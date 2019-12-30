#!/bin/bash

while getopts ":d" opt; do
  case "$opt" in
    d) DEBUG=true;;
    *) echo "Unknown option: $opt" >&2;;
  esac
done

info(){
  [ "$DEBUG" == 'true' ] || return 0
  echo "INFO: $1"
}

warn(){
  echo "WARNING: $1" >&2

}

error(){
  echo "ERROR: $1" >&2
  return 1
}

die(){
  echo "CRITICAL: $1" >&2
  exit 1
}

install(){
  FILE=${1-null}
  if [ -f ${FILE} ]; then
    info "Installing $FILE"
    ln -sf $(readlink -f $FILE) ~/$2 || error "Couldn't copy the file: $FILE!"
  elif [ -d ${FILE} ]; then
    info "Installing $FILE"
    [ -d ~/$FILE ] && rm -rf ~/$FILE
    ln -sf $(readlink -f $FILE) ~/$2 || error "Couldn't copy the directory: $FILE!"
  else
    error "File ${FILE} doesn't exist!"
  fi
}

install_bin(){
  install bin/$1 bin
}

# Create ~/bin if it doesn't exist
if [ ! -d ~/bin ]; then
  mkdir ~/bin
fi

install_bin nsgit
install .bashrc
install .bashrc.d
install .ircservers
install .tmux.conf
install .vim
install .vimrc
install .gitconfig
install .bash_profile
install .i3

# git-fugitive
# Git bindings for vim
FUGITIVEDIR=~/.vim/pack/tpope/start
if [ ! -d ${FUGITIVEDIR} ]; then
  mkdir -p ${FUGITIVEDIR}
  git clone https://tpope.io/vim/fugitive.git ${FUGITIVEDIR}/fugitive
  vim -u NONE -c "helptags fugitive/doc" -c q
fi

# jedi-vim
# Python autocomplete library for vim
if [ ! -d ~/.vim/bundle/jedi-vim ]; then
  git clone --recursive https://github.com/davidhalter/jedi-vim.git ~/.vim/bundle/jedi-vim
fi

# NERDtree
# Directory tree explorer for vim
if [ ! -d ~/.vim/bundle/nerdtree ]; then
  git clone --recursive https://github.com/scrooloose/nerdtree ~/.vim/bundle/nerdtree
fi

# bufexplorer
# Buffer explorer for vim
if [ ! -d ~/.vim/bundle/bufexplorer.vim ]; then
  git clone --recursive https://github.com/jlanzarotta/bufexplorer.git ~/.vim/bundle/bufexplorer.vim
fi
