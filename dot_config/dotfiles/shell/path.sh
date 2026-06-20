# shellcheck shell=sh

path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_append() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
}

[ -d "$HOME/.local/bin" ] && path_prepend "$HOME/.local/bin"
[ -d "$HOME/bin" ] && path_prepend "$HOME/bin"
[ -d "$HOME/.atuin/bin" ] && path_prepend "$HOME/.atuin/bin"
[ -d "$HOME/.n/bin" ] && path_prepend "$HOME/.n/bin"
[ -d "$HOME/.bun/bin" ] && path_prepend "$HOME/.bun/bin"
[ -d "$HOME/.opencode/bin" ] && path_prepend "$HOME/.opencode/bin"
[ -d "$HOME/.codeium/windsurf/bin" ] && path_prepend "$HOME/.codeium/windsurf/bin"
[ -d "$HOME/.antigravity/antigravity/bin" ] && path_prepend "$HOME/.antigravity/antigravity/bin"

if [ -n "${PNPM_HOME:-}" ]; then
  path_prepend "$PNPM_HOME"
elif [ -d "$HOME/Library/pnpm" ]; then
  PNPM_HOME="$HOME/Library/pnpm"
  export PNPM_HOME
  path_prepend "$PNPM_HOME"
fi

export PATH
