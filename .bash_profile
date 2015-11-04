
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ $- == *i* ]] && [[ -z "$TMUX" ]] && exec tmux
