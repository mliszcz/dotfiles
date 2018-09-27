
# bash/readline sequences \[ and \] work only when assigned directly to PS1
# when PS1 is generated with printf/echo, use raw codes for \001 and \002
# https://stackoverflow.com/questions/24839271/bash-ps1-line-wrap-issue-with-non-printing-characters-from-an-external-command

function __esc_seq {
  echo -ne '\001'"$1"'\002'
}

if [[ -n "$ZSH_VERSION" ]]; then
  function __esc_seq {
    echo -ne '%{'"$1"'%}'
  }
fi

COL_BLUE=$(__esc_seq '\033[0;94m')
COL_GREEN=$(__esc_seq '\033[0;32m')
COL_RED=$(__esc_seq '\033[0;91m')
COL_YELLOW=$(__esc_seq '\033[0;33m')
COL_BOLD_YELLOW=$(__esc_seq '\033[0;1;33m')
COL_OFF=$(__esc_seq '\033[0m')

unset -f __esc_seq

function __update_ps1() {
  local STATUS="$?"
  local USER="$1"
  local HOST="$2"
  local DIR="$3"

  local PS="${COL_BLUE}($USER@$HOST)${COL_OFF} "

  if git branch &>/dev/null && type __git_ps1 &>/dev/null; then
    if [[ -z $(git status --porcelain 2>/dev/null) ]]; then
      PS+="${COL_GREEN}$(__git_ps1 '(%s)')${COL_OFF} "
    else
      PS+="${COL_RED}$(__git_ps1 '{%s}')${COL_OFF} "
    fi
    PS+="${COL_BOLD_YELLOW}$DIR${COL_OFF} "
  else
    PS+="${COL_YELLOW}$DIR${COL_OFF} "
  fi

  if [[ "$STATUS" -eq 0 ]]; then
    PS+="$ "
  else
    PS+="${COL_RED}\$${COL_OFF} "
  fi

  echo -ne "$PS"
}

export GIT_PS1_SHOWDIRTYSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=

