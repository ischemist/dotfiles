autoload -Uz vcs_info
zmodload zsh/datetime

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%b%c%u'
zstyle ':vcs_info:git:*' actionformats '%b|%a%c%u'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '!'

setopt prompt_subst
unsetopt beep

typeset -g __morgunov_cmd_started_at=0

__morgunov_preexec() {
  __morgunov_cmd_started_at=$EPOCHSECONDS
}

__morgunov_git_segment() {
  local info="${vcs_info_msg_0_}"
  [[ -z "$info" ]] && return

  local branch="${info%%[+!]*}"
  local color="%F{120}"

  [[ "$info" == *[+!]* ]] && color="%F{214}"
  [[ "$branch" == "main" || "$branch" == "master" ]] && color="%F{197}"

  print -n " [${color}${info}%f]"
}

__morgunov_runtime_segment() {
  local parts=()
  local py_version

  if [[ -n "$VIRTUAL_ENV" ]]; then
    parts+=("py:${VIRTUAL_ENV:t}")
  elif [[ -f uv.lock || -f pyproject.toml ]] && command -v uv >/dev/null 2>&1; then
    py_version="$(uv run python -V 2>/dev/null | awk '{print $2}')"
    [[ -n "$py_version" ]] && parts+=("py:${py_version}")
  elif [[ -f pyproject.toml || -f requirements.txt || -f setup.py ]]; then
    parts+=("py:$(python3 --version 2>/dev/null | awk '{print $2}')")
  fi

  if [[ -f package.json || -f pnpm-lock.yaml || -f package-lock.json || -f yarn.lock || -f bun.lockb ]]; then
    parts+=("node:$(node --version 2>/dev/null | sed 's/^v//')")
  fi

  (( ${#parts[@]} )) && print -n "%F{245}${(j: :)parts}%f"
}

__morgunov_duration_segment() {
  local elapsed=$(( EPOCHSECONDS - __morgunov_cmd_started_at ))
  (( __morgunov_cmd_started_at == 0 || elapsed < 5 )) && return

  if (( elapsed < 60 )); then
    print -n " %F{245}${elapsed}s%f"
  else
    print -n " %F{245}$(( elapsed / 60 ))m$(( elapsed % 60 ))s%f"
  fi
}

__morgunov_precmd() {
  local last_status=$?

  vcs_info

  PROMPT='%F{141}%~%f$(__morgunov_git_segment) '
  RPROMPT='$(__morgunov_runtime_segment)'

  if (( last_status != 0 )); then
    RPROMPT="%F{197}${last_status}%f ${RPROMPT}"
  fi

  RPROMPT+='$(__morgunov_duration_segment)'
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __morgunov_precmd
add-zsh-hook preexec __morgunov_preexec
