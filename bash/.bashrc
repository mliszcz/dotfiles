#
# ~/.bashrc
#

[[ $- != *i* ]] && return

function __source_dir {
  local HAS_NULLGLOB=
  shopt -q nullglob || HAS_NULLGLOB=1
  shopt -s nullglob
  for f in $1/*{.sh,.bash}; do [[ -r $f ]] && source $f; done
  [[ -z "$HAS_NULLGLOB" ]] && shopt -u nullglob
}

__source_dir ~/.shellrc.d/pre

export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTFILESIZE=$HISTSIZE
export HISTFILE=~/.histfile

export HISTCONTROL=ignoreboth:erasedups

shopt -s histappend
shopt -s globstar
shopt -s checkwinsize

export PS1='$(__update_ps1 "\u" "\H" "\w")'

__source_dir ~/.shellrc.d/post

unset -f __source_dir

hash khal 2>/dev/null && khal && printf "\n"
