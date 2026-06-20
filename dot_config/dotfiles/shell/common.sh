# shellcheck shell=sh

DOTFILES_CONFIG_HOME="${DOTFILES_CONFIG_HOME:-$HOME/.config/dotfiles}"
export DOTFILES_CONFIG_HOME

if [ -n "${SSH_TTY:-}" ] && [ "${TERM:-}" = "dumb" ]; then
  export TERM="xterm-256color"
fi

# shellcheck source=/dev/null
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# shellcheck source=/dev/null
[ -f "$DOTFILES_CONFIG_HOME/shell/path.sh" ] && . "$DOTFILES_CONFIG_HOME/shell/path.sh"
# shellcheck source=/dev/null
[ -f "$DOTFILES_CONFIG_HOME/shell/aliases.sh" ] && . "$DOTFILES_CONFIG_HOME/shell/aliases.sh"
# shellcheck source=/dev/null
[ -f "$DOTFILES_CONFIG_HOME/shell/functions.sh" ] && . "$DOTFILES_CONFIG_HOME/shell/functions.sh"

export EDITOR="${EDITOR:-vim}"
export GHOSTTYCONF="${GHOSTTYCONF:-$HOME/Library/Application Support/com.mitchellh.ghostty/config}"
