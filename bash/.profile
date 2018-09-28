#
# ~/.profile
#

[[ -d ~/.local/bin ]] && export PATH=$PATH:~/.local/bin

export HISTSIZE=100000
export HISTFILESIZE=100000

export LESS='-W -i'

if hash nvim 2>/dev/null; then
  export EDITOR=nvim
elif hash vim 2>/dev/null; then
  export EDITOR=vim
elif hash vi 2>/dev/null; then
  export EDITOR=vi
fi

if hash fzf 2>/dev/null; then
  if hash fd 2>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --hidden --follow --type f -E ".git/" -E ".svn/" .'
  elif hash rg 2>/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!.svn/*"'
  elif hash pt 2>/dev/null; then
    export FZF_DEFAULT_COMMAND='pt --hidden -g ""'
  fi
fi

if [[ "$XDG_SESSION_TYPE" = 'x11' ]] || \
  [[ -n "$SSH_CLIENT" ]] && [[ -n "$DISPLAY" ]]; then
  if hash xclip 2>/dev/null; then
    export CLIPBOARD_COPY_CMD='xclip -in -selection clipboard'
    export CLIPBOARD_PASTE_CMD='xclip -out -selection clipboard'
  elif hash xsel 2>/dev/null; then
    export CLIPBOARD_COPY_CMD='xsel --input --clipboard'
    export CLIPBOARD_PASTE_CMD='xsel --output --clipboard'
  fi
elif [[ -n "$SSH_CLIENT" ]] && hash lemonade 2>/dev/null; then
  LEMONADE_SERVER=$(cut -d' ' -f1 <<< $SSH_CLIENT)
  export CLIPBOARD_COPY_CMD="lemonade copy --host $LEMONADE_SERVER"
  export CLIPBOARD_PASTE_CMD="lemonade paste --host $LEMONADE_SERVER"
fi

# keys: https://github.com/ogham/exa/blob/075fe802b49438aac8452622f69c8933f2308e23/src/style/colours.rs#L197
# values are terminal color codes
export EXA_COLORS='uu=38;5;166:gu=38;5;166'
