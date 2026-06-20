# shellcheck shell=bash

case $- in
  *i*) ;;
  *) return 0 ;;
esac

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

if command -v fzf >/dev/null 2>&1; then
  fzf_base="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf"
  # shellcheck source=/dev/null
  [ -f "$fzf_base/shell/completion.bash" ] && . "$fzf_base/shell/completion.bash"
  # shellcheck source=/dev/null
  [ -f "$fzf_base/shell/key-bindings.bash" ] && . "$fzf_base/shell/key-bindings.bash"
  unset fzf_base
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init bash)"
fi

if [ "${TERM:-}" != "dumb" ] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
