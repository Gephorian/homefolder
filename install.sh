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

install_vim_plugin(){
  install vim_plugins/$1 .vim/plugin
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
  install .yamlfmt
elif [ "$MACOS" == 'true' ]; then # Mac/work setup
  install .tmux.conf
  install .vim
  install .vimrc
  install .yamlfmt

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
  git clone --depth=1 https://github.com/sheerun/vim-polyglot ${POLYGLOTDIR}
fi

# ale
# Linting and syntax checking for a LOT of languages
ALEDIR=~/.vim/bundle/ale
if [ ! -d ${ALEDIR} ]; then
  mkdir -p ${ALEDIR}
  git clone --depth=1 https://github.com/dense-analysis/ale ${ALEDIR}
fi

# vim-docker-tools
# Docker toolkit
# Only install if Docker exists
if which docker 2>&1 >/dev/null; then
  DOCKERDIR=~/.vim/bundle/vim-docker-tools
  if [ ! -d ${DOCKERDIR} ]; then
    mkdir -p ${DOCKERDIR}
    git clone --depth=1 https://github.com/kkvh/vim-docker-tools.git ${DOCKERDIR}
  fi
  install_vim_plugin vim-docker-tools.vim
fi

# git-fugitive
# Git bindings for vim
FUGITIVEDIR=~/.vim/pack/tpope/start
if [ ! -d ${FUGITIVEDIR} ]; then
  mkdir -p ${FUGITIVEDIR}
  git clone --depth=1 https://tpope.io/vim/fugitive.git ${FUGITIVEDIR}/fugitive
  vim -u NONE -c "helptags fugitive/doc" -c q
fi

# jedi-vim
# Python autocomplete library for vim
if [ ! -d ~/.vim/bundle/jedi-vim ]; then
  git clone --depth=1 --recursive https://github.com/davidhalter/jedi-vim.git ~/.vim/bundle/jedi-vim
fi

# NERDtree
# Directory tree explorer for vim
if [ ! -d ~/.vim/bundle/nerdtree ]; then
  git clone --depth=1 --recursive https://github.com/scrooloose/nerdtree ~/.vim/bundle/nerdtree
fi

# NERDcommenter
# Easy context-sensitive comment shortcut
if [ ! -d ~/.vim/bundle/nerdcommenter ]; then
  git clone --depth=1 --recursive https://github.com/preservim/nerdcommenter ~/.vim/bundle/nerdcommenter
fi

# bufexplorer
# Buffer explorer for vim
if [ ! -d ~/.vim/bundle/bufexplorer.vim ]; then
  git clone --depth=1 --recursive https://github.com/jlanzarotta/bufexplorer.git ~/.vim/bundle/bufexplorer.vim
fi

# vim-yaml-fold
# Line folder for YAML
if [ ! -d ~/.vim/bundle/vim-yaml-folds.vim ]; then
  git clone --depth=1 --recursive https://github.com/pedrohdz/vim-yaml-folds ~/.vim/bundle/vim-yaml-folds.vim
fi

# indentline
# Shows indentations using vertical lines
if [ ! -d ~/.vim/bundle/indentline.vim ]; then
  git clone --depth=1 --recursive https://github.com/Yggdroot/indentLine ~/.vim/bundle/indentline.vim
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

GITCONFIG_LOCAL=${GITCONFIG_LOCAL:-~/.gitconfig_local}
if [ ! -e "${GITCONFIG_LOCAL}" ]; then
  echo "List of current gpg keys:"
  gpg2 --list-keys --keyid-format=long || gpg --list-keys --keyid-format=long
  read -p "Git email: " email
  read -p "Git name:  " name
  read -p "GPG key:   " gpgkey
  cat > ${GITCONFIG_LOCAL} <<EOF
[user]
  email = ${email}
  name  = ${name}
EOF
  [ -n "${gpgkey}" ] && \
    cat >> ${GITCONFIG_LOCAL} <<EOF
  signingkey = ${gpgkey}
[commit]
  gpgsign = true
[gpg]
  program = $(which gpg2 || which gpg)
EOF
  echo "Base git config written to '${GITCONFIG_LOCAL}'."
fi
