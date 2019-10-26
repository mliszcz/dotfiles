#
# ~/.profile
#

[[ -d ~/.local/bin ]] && export PATH=$PATH:~/.local/bin
[[ -d ~/go/bin ]] && export PATH=$PATH:~/go/bin

export LESS='-W -i -R'

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
  else
    export CLIPBOARD_COPY_CMD=":"
    export CLIPBOARD_PASTE_CMD=":"
  fi
elif [[ -n "$WAYLAND_DISPLAY" ]] \
  && hash wl-copy 2>/dev/null \
  && hash wl-paste 2>/dev/null; then
  export CLIPBOARD_COPY_CMD='wl-copy'
  export CLIPBOARD_PASTE_CMD='wl-paste --no-newline'
elif [[ -n "$SSH_CLIENT" ]] && hash lemonade 2>/dev/null; then
  LEMONADE_SERVER=$(cut -d' ' -f1 <<< $SSH_CLIENT)
  export CLIPBOARD_COPY_CMD="lemonade copy --host $LEMONADE_SERVER"
  export CLIPBOARD_PASTE_CMD="lemonade paste --host $LEMONADE_SERVER"
else
  export CLIPBOARD_COPY_CMD=":"
  export CLIPBOARD_PASTE_CMD=":"
fi

