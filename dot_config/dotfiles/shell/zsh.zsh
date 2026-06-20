case $- in
  *i*) ;;
  *) return 0 ;;
esac

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if [[ -o zle ]] && command -v fzf >/dev/null 2>&1; then
  fzf_base="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf"
  [ -f "$fzf_base/shell/completion.zsh" ] && source "$fzf_base/shell/completion.zsh"
  [ -f "$fzf_base/shell/key-bindings.zsh" ] && source "$fzf_base/shell/key-bindings.zsh"
  unset fzf_base
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

if [ "${TERM:-}" != "dumb" ] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
