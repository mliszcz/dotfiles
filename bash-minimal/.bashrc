# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls --color=auto -lah'

PS1='[\u@\h \W]\$ '
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash_history"
