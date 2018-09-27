#
# ~/.zshrc
#

[[ $- != *i* ]] && return

for f in ~/.shellrc.d/*{.sh,.zsh}; do [[ -f $f ]] && source $f; done

# zstyle ':completion:*' completer _complete _ignored
# zstyle :compinstall filename '/home/michal/.zshrc'

# autoload -Uz compinit
# compinit

HISTFILE=~/.histfile

setopt PROMPT_SUBST

export PS1='ZSH $(__update_ps1 "%n" "%M" "%~")'

export SAVEHIST=$HISTSIZE

bindkey -v

