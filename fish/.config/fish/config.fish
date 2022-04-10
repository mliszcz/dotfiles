
set fish_prompt_pwd_dir_length 0

fish_vi_key_bindings

set fish_cursor_default     block      blink
set fish_cursor_insert      line       blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual      block

fzf_key_bindings

alias ll='exa --long --classify --all --group --git --sort=name'
alias tree='exa --tree --long --classify --all --group --sort=name -I=".git|.svn"'
alias cat='bat'

# CTRL-f completes and executes the autosuggestion.
bind -s -M insert \ce forward-char
bind -s -M insert \cf forward-char execute
