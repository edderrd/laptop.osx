function ssh_connection() {
    if $SHOW_HOST ; then
        HOSTER="%{$fg[yellow]%}%m "
    else
        HOSTER=""
    fi
    if [[ -n $SSH_CONNECTION ]]; then
        echo "%{$fg[cyan]%}☁  $HOSTER"
    fi
}

function show_user() {
    local user=`whoami`
    if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="cyan"; fi

    if [[ "$user" != "$DEFAULT_USER" ]]; then
        echo " %{$fg[$NCOLOR]%}%n%{$fg[white]%}"
    fi
}

function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)%{$fg[yellow]%})%{$fg_bold[yellow]%}$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}


function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}


PROMPT='$(ssh_connection)%{$fg_bold[red]%}➜ $(show_user)%{$fg_bold[green]%}%p %{$fg[blue]%}%~ %{$fg_bold[blue]%}$(my_git_prompt)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}]"

ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[blue]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[yellow]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"