set fish_prompt_pwd_dir_length 0

set fish_cursor_default     block      blink
set fish_cursor_insert      line       blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual      block

set fish_color_command blue

alias ll='eza --long --classify --all --group --sort=name'
alias tree='eza --tree --long --classify --all --group --sort=name -I=".git|.svn"'
alias cat='bat'

fish_vi_key_bindings

if type -q fzf
  fzf --fish | source
end

# Use $dir to narrow CTRL-t search results to start with what is already typed.
# Note: this variable is provided by the fzf extension only for the fish shell.
# It cannot go into .profile because it would break bash.
if type -q fzf; and type -q fd; and set -q FZF_DEFAULT_COMMAND
  set -g FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND --search-path \$dir"
end

# CTRL-f completes and executes the autosuggestion.
bind -s -M insert \ce forward-char
bind -s -M insert \cf forward-char execute

# Allow switching back to a program backgrounded with CTRL-Z.
bind -s -M default \cz 'fg 2>/dev/null; commandline -f repaint'
bind -s -M insert  \cz 'fg 2>/dev/null; commandline -f repaint'
