
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

COL_BLUE=$(__esc_seq '\033[94m')
COL_GREEN=$(__esc_seq '\033[32m')
COL_RED=$(__esc_seq '\033[91m')
COL_YELLOW=$(__esc_seq '\033[33m')
COL_YELLOW_B=$(__esc_seq '\033[93m')
COL_BOLD=$(__esc_seq '\033[1m')
COL_OFF=$(__esc_seq '\033[39m')

# this should be 21, but vte expects 22
# https://github.com/kovidgoyal/kitty/issues/226
COL_BOLD_OFF=$(__esc_seq '\033[22m')

unset -f __esc_seq

# proper solution is: git rev-parse --is-inside-work-tree &>/dev/null
# 15 times faster (on slow hdd) solution is below:
function __is_git_repository {
  [[ -d .git \
  || -d ../.git \
  || -d ../../.git \
  || -d ../../../.git \
  || -d ../../../../.git \
  || -d ../../../../../.git \
  || -d ../../../../../../.git \
  || -d ../../../../../../../.git \
  || -d ../../../../../../../../.git \
  || -d ../../../../../../../../../.git ]]
}

function __is_git_repository {
  git branch &>/dev/null
}

function __update_ps1() {
  local USER="$1"
  local HOST="$2"
  local DIR="$3"
  local STATUS="${4:-$?}"

  local PS="${COL_BLUE}($USER@$HOST)${COL_OFF} "

  if __is_git_repository && type __git_ps1 &>/dev/null; then
    if [[ -z $(git status --porcelain 2>/dev/null) ]]; then
      PS+="${COL_GREEN}$(__git_ps1 '(%s)')${COL_OFF} "
    else
      PS+="${COL_RED}$(__git_ps1 '{%s}')${COL_OFF} "
    fi
    PS+="${COL_YELLOW_B}${COL_BOLD}$DIR${COL_BOLD_OFF}${COL_OFF} "
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

