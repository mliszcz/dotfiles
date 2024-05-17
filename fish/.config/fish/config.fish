
set fish_prompt_pwd_dir_length 0

fish_vi_key_bindings

set fish_cursor_default     block      blink
set fish_cursor_insert      line       blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual      block

fzf_key_bindings

alias ll='eza --long --classify --all --group --sort=name'
alias tree='eza --tree --long --classify --all --group --sort=name -I=".git|.svn"'
alias cat='bat'

# CTRL-f completes and executes the autosuggestion.
bind -s -M insert \ce forward-char
bind -s -M insert \cf forward-char execute

# Allow switching back to a program backgrounded with CTRL-Z.
bind -s -M default \cz 'fg 2>/dev/null; commandline -f repaint'
bind -s -M insert  \cz 'fg 2>/dev/null; commandline -f repaint'

# Overwrite the default delete-or-exit behavior for CTRL-D.
bind -s -M default --erase --preset \cd
bind -s -M insert  --erase --preset \cd
