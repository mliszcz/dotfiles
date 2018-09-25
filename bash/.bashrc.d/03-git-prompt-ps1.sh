
COL_BLUE='\001\033[0;94m\002'
COL_GREEN='\001\033[0;32m\002'
COL_RED='\001\033[0;91m\002'
COL_YELLOW='\001\033[0;33m\002'
COL_BOLD_YELLOW='\001\033[0;1;33m\002'
COL_OFF='\001\033[0m\002'

function __update_ps1() {
  local STATUS="$?"
  local USER="$1"
  local HOST="$2"
  local DIR="$3"

  local PS="${COL_BLUE}($USER@$HOST)${COL_OFF} "

  if git branch &>/dev/null && type -t __git_ps1 &>/dev/null; then
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

  printf "$PS"
}

export GIT_PS1_SHOWDIRTYSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=
export PS1='$(__update_ps1 "\u" "\H" "\w")'

