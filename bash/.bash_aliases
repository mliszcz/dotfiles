#
# ~/.bash_aliases
#

alias ls='ls --color=auto'
alias ssh='ssh -XC -c blowfish-cbc,arcfour'
alias ssh-phone='/usr/bin/ssh -p 2222 -c aes128-gcm@openssh.com root@black'

if hash exa 2>/dev/null; then
  alias ll='exa -lag --git'
else
  alias ll='ls -lAhF --color=always | tail -n +2'
fi

if hash pygmentize 2>/dev/null; then
  alias hl='pygmentize -g'
elif hash highlight 2>/dev/null; then
  alias hl='highlight -O ansi --failsafe'
fi

# alias sway='GDK_BACKEND=wayland CLUTTER_BACKEND=wayland WLC_XWAYLAND=0 sway -dV 1>~/swaylog 2>&1'
# alias sway='GDK_BACKEND=wayland CLUTTER_BACKEND=wayland WLC_XWAYLAND=1 sway -dV 1>~/swaylog 2>&1'
alias sway='sway -dV 1>~/swaylog 2>&1'
