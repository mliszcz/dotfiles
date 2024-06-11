export LESS="--HILITE-UNREAD --ignore-case --RAW-CONTROL-CHARS -M"

export MOZ_ENABLE_WAYLAND=1

if command -v nvim >/dev/null; then
  export EDITOR=nvim
elif command -v vim >/dev/null; then
  export EDITOR=vim
elif command -v vi >/dev/null; then
  export EDITOR=vi
fi

if command -v fzf >/dev/null; then
  if command -v fd >/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --hidden --follow --type f --color=always -E .git -E .svn'
    export FZF_DEFAULT_OPTS="--ansi"
  elif command -v rg >/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!.svn/*"'
  elif command -v pt >/dev/null; then
    export FZF_DEFAULT_COMMAND='pt --hidden -g ""'
  fi
fi

if command -v bat >/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=\"Solarized (dark)\"'"
  export MANROFFOPT="-c"
elif command -v nvim >/dev/null; then
  export MANPAGER='nvim +Man!'
fi
