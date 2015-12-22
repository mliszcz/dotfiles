# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# History
export HISTCONTROL=ignoreboth

# Editor
if which vim >/dev/null 2>&1; then
  export EDITOR=vim
elif which vi >/dev/null 2>&1; then
  export EDITOR=vi
fi

# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# X-forwarding and compression for SSH
alias ssh='ssh -XC -c blowfish-cbc,arcfour'

# Source alias definitions
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

# Source scripts from ~/.bashrc.d
for f in ~/.bashrc.d/*; do
  if [ -f $f ]; then
    source $f
  fi
done
