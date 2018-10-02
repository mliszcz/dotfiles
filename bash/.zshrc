#
# ~/.zshrc
#

[[ ! -o interactive ]] && return

for f in ~/.shellrc.d/*{.sh,.zsh}; do [[ -r $f ]] && source $f; done

autoload -Uz compinit
compinit

# do I need this?
zstyle ':completion:*' use-compctl false

export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTFILESIZE=100000 # check what it is
export HISTFILE=~/.histfile

zmodload -i zsh/complist

# use LS_COLORS (dircolors -s)
zstyle ':completion:*' list-colors ''

# enable parameter expansion in PS1
setopt promptsubst

setopt histverify
setopt appendhistory incappendhistory sharehistory
setopt histignorealldups
setopt histignorespace
setopt nobeep nohistbeep autocd

# why git completion misses commits

# setopt bashautolist
setopt recexact
unsetopt automenu
unsetopt menucomplete
setopt completeinword
setopt alwaystoend
# setopt listambiguous
# for some reason <tab> still cycles e.g. through options in ps
#
export PS1=$(echo -ne '%{\033[3m%}')'$(__update_ps1 "%n" "%M" "%~")'
function preexec { echo -ne '\033[23m' }

zstyle ':completion:*' menu false

# TODO gray text after prediction

autoload predict-on predict-off
zle -N predict-on
zle -N predict-off
# predict-on

# (1) https://superuser.com/questions/476532/how-can-i-make-zshs-vi-mode-behave-more-like-bashs-vi-mode
bindkey '^?' backward-delete-char
bindkey '^[[3~' delete-char

# from (1)
vi-search-fix() {
  zle vi-cmd-mode
  zle .vi-history-search-backward
}

zle -N vi-search-fix
bindkey -M viins '\e/' vi-search-fix

bindkey -v

# https://superuser.com/questions/361335/how-to-change-the-terminal-cursor-from-box-to-line
# http://lynnard.me/blog/2014/01/05/change-cursor-shape-for-zsh-vi-mode/
function zle-keymap-select {
  if [ "$TERM" = "xterm-256color" ] || true; then
    if [ $KEYMAP = vicmd ]; then
      # blinking block
      echo -ne "\e[2 q"
    else
      # blinking bar
      echo -ne "\e[6 q"
    fi
  fi
}

function zle-line-finish {
  echo -ne "\e[2 q"
}


zle -N zle-keymap-select
zle -N zle-line-init zle-keymap-select
zle -N zle-line-finish
