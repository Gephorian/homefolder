#!/bin/bash

MACOS=false
[[ -e "/Users" && ! -e "/proc/" ]] && MACOS=true

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
  [ "$MACOS" == 'true' ] && READLINK=greadlink || READLINK=readlink
  if [ -f ${FILE} ]; then
    info "Installing $FILE"
    ln -sf $($READLINK -f $FILE) ~/$2 || error "Couldn't copy the file: $FILE!"
  elif [ -d ${FILE} ]; then
    info "Removing original and installing $FILE"
    [ -d ~/$FILE ] && rm -rf ~/$FILE
    ln -sf $($READLINK -f $FILE) ~/$2 || error "Couldn't copy the directory: $FILE!"
  else
    error "File ${FILE} doesn't exist!"
  fi
}

install_bin(){
  install bin/$1 bin
}

# Checks
if [ "$MACOS" == 'true' ]; then
  which greadlink >/dev/null || die "MACOS requires greadlink. Do 'brew install coreutils'"
fi

# Create ~/bin if it doesn't exist
if [ ! -d ~/bin ]; then
  mkdir ~/bin
fi

if [ ! "$MACOS" == 'true' ]; then # Bastion/linux/home setup
  install_bin nsgit
  install .gitconfig
  install .bashrc
  install .bashrc.d
  install .bash_profile
  install .tmux.conf
  install .vim
  install .vimrc
elif [ "$MACOS" == 'true' ]; then # Mac/work setup
  install .tmux.conf
  install .vim
  install .vimrc

  # Install "oh-my-zsh"
  [ ! -e ~/.oh-my-zsh ] &&  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  install .zshrc
  [ -d ~/.zshrc.d ] || mkdir ~/.zshrc.d
  # Install plugins
  ZSHZDIR=~/.oh-my-zsh/custom/plugins/zsh-z
  if [ ! -d $ZSHZDIR ]; then
    git clone https://github.com/agkozak/zsh-z $ZSHZDIR
  fi
fi

# vim-polyglot
# Syntax highlighting and checking for a LOT of languages
POLYGLOTDIR=~/.vim/bundle/vim-polyglot
if [ ! -d ${POLYGLOTDIR} ]; then
  mkdir -p ${POLYGLOTDIR}
  git clone https://github.com/sheerun/vim-polyglot ${POLYGLOTDIR}
fi

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

# NERDcommenter
# Easy context-sensitive comment shortcut
if [ ! -d ~/.vim/bundle/nerdcommenter ]; then
  git clone --recursive https://github.com/preservim/nerdcommenter ~/.vim/bundle/nerdcommenter
fi

# bufexplorer
# Buffer explorer for vim
if [ ! -d ~/.vim/bundle/bufexplorer.vim ]; then
  git clone --recursive https://github.com/jlanzarotta/bufexplorer.git ~/.vim/bundle/bufexplorer.vim
fi

# fzf
# Fuzzy Finder
if [ ! -d ~/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --no-key-bindings --no-completion --no-update-rc
  (
    cd ~/.fzf/bin
    for i in *; do
      ln -s ~/.fzf/bin/$i ~/bin/
    done
  )
fi

for i in ~/.swp ~/.undodir ~/.backup; do
  if [ ! -d $i ]; then
    echo $i does not exist, creating...
    mkdir $i
  fi
done
