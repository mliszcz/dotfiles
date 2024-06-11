# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls --color=auto -lah'

PS1='[\u@\h \W]\$ '

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash_history"
HISTCONTROL=ignoreboth:erasedups

if [ "${BASH_VERSINFO[0]}${BASH_VERSINFO[1]}" -ge 43 ]
then
  HISTSIZE=-1
  HISTFILESIZE=-1
else
  HISTSIZE=
  HISTFILESIZE=
fi

shopt -s histappend
shopt -s globstar
shopt -s checkwinsize
