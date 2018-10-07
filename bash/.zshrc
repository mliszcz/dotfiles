#
# ~/.zshrc
#

[[ ! -o interactive ]] && return

function __source_dir {
  local HAS_NULLGLOB=
  [[ -o nullglob ]] || HAS_NULLGLOB=1
  setopt nullglob
  for f in $1/*{.sh,.zsh}; do [[ -r $f ]] && source $f; done
  [[ -z "$HAS_NULLGLOB" ]] && unsetopt nullglob
}

__source_dir ~/.shellrc.d/pre

zmodload -i zsh/complist

autoload -Uz compinit
compinit

# options ---------------------------------------------------------------------

unsetopt autocd
unsetopt beep
setopt promptsubst

# history ---------------------------------------------------------------------

export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTFILESIZE=$HISTSIZE
export HISTFILE=~/.histfile

setopt appendhistory
unsetopt histbeep
setopt histignorealldups
setopt histignorespace
setopt histverify
setopt incappendhistory
setopt sharehistory

# completion ------------------------------------------------------------------

zstyle ':completion:*' use-compctl false
zstyle ':completion:*' menu false
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' insert-tab false

setopt alwaystoend
setopt autolist
unsetopt automenu
setopt completeinword
unsetopt listambiguous
unsetopt menucomplete
unsetopt recexact

# bindings --------------------------------------------------------------------

bindkey '^j' autosuggest-execute
bindkey '^?' backward-delete-char # fix backspace behavior in vi normal mode
bindkey '^[[3~' delete-char       # fix delete behavior in vi normal mode

# prompt ----------------------------------------------------------------------

function __vi_mode_ps1 {
  if [[ "$KEYMAP" = vicmd ]]; then
    echo -ne '%{\033[1;39m%}:%{\033[22;39m%}'
  else
    echo -ne '%{\033[1;31m%}+%{\033[22;39m%}'
  fi
}

export PS1='$(__vi_mode_ps1)$(__update_ps1 "%n" "%M" "%~")'

if [[ "$COLORTERM" = truecolor ]]; then
  export PS1=$(echo -ne '%{\033[3m%}')"$PS1"
  function preexec { echo -ne '\033[23m' }
fi

# vi mode ---------------------------------------------------------------------

bindkey -v

# https://superuser.com/questions/476532/how-can-i-make-zshs-vi-mode-behave-more-like-bashs-vi-mode
function __vi_search_fix {
  zle vi-cmd-mode
  zle .vi-history-search-backward
}

zle -N __vi_search_fix
bindkey -M viins '\e/' __vi_search_fix

# https://superuser.com/questions/361335/how-to-change-the-terminal-cursor-from-box-to-line
# http://lynnard.me/blog/2014/01/05/change-cursor-shape-for-zsh-vi-mode/

function __vi_reset_cursor {
  zle reset-prompt # update status in PS1
  if [[ "$COLORTERM" = truecolor ]]; then
    echo -ne "\e[2 q" # solid, block
  fi
}

function __vi_change_cursor {
  zle reset-prompt # update status in PS1
  if [[ "$COLORTERM" = truecolor ]]; then
    if [[ "$KEYMAP" = vicmd ]]; then
      echo -ne "\e[2 q" # solid, block
    else
      echo -ne "\e[6 q" # solid, bar
    fi
  fi
}

zle -N zle-keymap-select __vi_change_cursor
zle -N zle-line-init __vi_change_cursor
zle -N zle-line-finish __vi_reset_cursor

# post scripts ----------------------------------------------------------------

__source_dir ~/.shellrc.d/post

unset -f __source_dir

