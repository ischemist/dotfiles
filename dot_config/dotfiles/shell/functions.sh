# shellcheck shell=sh

has() {
  command -v "$1" >/dev/null 2>&1
}

tunnel() {
  if ! has autossh; then
    printf '%s\n' "autossh is not installed" >&2
    return 127
  fi

  autossh -M 0 -N \
    -o "serveraliveinterval=30" \
    -o "serveralivecountmax=3" \
    "$@"
}

ghostty_terminfo_source() {
  if [ -d "/Applications/Ghostty.app/Contents/Resources/terminfo" ]; then
    TERMINFO="/Applications/Ghostty.app/Contents/Resources/terminfo" infocmp -x xterm-ghostty
  elif has infocmp; then
    infocmp -x xterm-ghostty
  else
    printf '%s\n' "infocmp is not installed" >&2
    return 127
  fi
}

ghostty_terminfo_install() {
  if [ "$#" -lt 1 ]; then
    printf '%s\n' "usage: ghostty_terminfo_install <ssh-host>" >&2
    return 2
  fi

  ghostty_terminfo_source | ssh "$@" 'mkdir -p "$HOME/.terminfo" && tic -x -'
}

mkcd() {
  mkdir -p "$1" && cd "$1" || return
}

fd_find() {
  if has fd; then
    fd "$@"
  elif has fdfind; then
    fdfind "$@"
  else
    printf '%s\n' "fd is not installed" >&2
    return 127
  fi
}

cdd() {
  # shellcheck disable=SC3043
  local cdd_dir cdd_query

  if ! has fzf; then
    printf '%s\n' "fzf is not installed" >&2
    return 127
  fi

  cdd_query="$*"
  cdd_dir=$(fd_find -t d . | fzf --query "$cdd_query") || return
  [ -n "$cdd_dir" ] || return
  cd "$cdd_dir" || return
}

sg_dotfiles() {
  if ! has sg; then
    printf '%s\n' "ast-grep is not installed" >&2
    return 127
  fi

  sg scan --config "$HOME/.config/dotfiles/ast-grep/sgconfig.yml" "$@"
}
