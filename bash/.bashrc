#
# ~/.bashrc
#

[[ $- != *i* ]] && return

[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
shopt -s globstar
shopt -s checkwinsize

for f in ~/.bashrc.d/*; do [[ -f $f ]] && source $f; done

export PS1='$(__update_ps1 "\u" "\H" "\w")'

hash khal 2>/dev/null && khal && printf "\n"
