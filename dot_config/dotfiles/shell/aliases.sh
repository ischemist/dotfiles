# shellcheck shell=sh

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -lah --icons=auto --git --group-directories-first'
  alias la='eza -la --icons=auto --group-directories-first'
  alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
else
  alias ll='ls -lah'
  alias la='ls -la'
fi

alias grep='grep --color=auto'
alias lg='lazygit'
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
fi
alias ..='cd ..'
alias ...='cd ../..'
alias sg-dotfiles='sg_dotfiles'

alias next-tree='tree src -I "node_modules|.next|_int|.git|dist|build|public|package-lock.json|pnpm-lock.yaml"'
alias grow-local-start='docker compose -f "$HOME/Developer/personal/grow/docker-compose.yml" -f "$HOME/Developer/personal/grow/docker-compose.local.yml" up -d --build --no-deps app'
alias grow-local-stop='docker compose -f "$HOME/Developer/personal/grow/docker-compose.yml" -f "$HOME/Developer/personal/grow/docker-compose.local.yml" stop app'
