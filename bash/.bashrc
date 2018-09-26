#
# ~/.bashrc
#

[[ $- != *i* ]] && return

for f in ~/.shellrc.d/*{.sh,.bash}; do [[ -f $f ]] && source $f; done

export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
shopt -s globstar
shopt -s checkwinsize

export PS1='$(__update_ps1 "\u" "\H" "\w")'

hash khal 2>/dev/null && khal && printf "\n"
