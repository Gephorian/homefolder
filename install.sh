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
    cp -r $FILE ~ || error "Couldn't copy the file: $FILE!"
  elif [ -d ${FILE} ]; then
    info "Installing $FILE"
    cp -r $FILE ~ || error "Couldn't copy the directory: $FILE!"
  else
    error "File ${FILE} doesn't exist!"
  fi
}

install .bashrc
install .bashrc.d
install .ircservers
install .tmux.conf
install .vim
install .viminfo
install .vimrc
install .gitconfig
