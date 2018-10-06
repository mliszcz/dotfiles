#
# ~/.bashrc
#

[[ $- != *i* ]] && return

for f in ~/.shellrc.d/*{.sh,.bash}; do [[ -f $f ]] && source $f; done

export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTFILESIZE=$HISTSIZE
export HISTFILE=~/.histfile

export HISTCONTROL=ignoreboth:erasedups

shopt -s histappend
shopt -s globstar
shopt -s checkwinsize

export PS1='$(__update_ps1 "\u" "\H" "\w")'

hash khal 2>/dev/null && khal && printf "\n"
