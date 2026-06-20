# dependency install policy

prefer direct upstream installers when the project has a real one. use homebrew/apt for boring system packages and tools whose upstream install story is package-manager-first or binary-release-only.

## direct installers

| tool | install path | source |
| --- | --- | --- |
| chezmoi | `sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"` | official install script |
| uv | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | official install script |
| atuin | `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh \| sh` | official install script |
| starship | `curl -sS https://starship.rs/install.sh \| env BIN_DIR="$HOME/.local/bin" sh -s -- --yes` | official install script |
| mise | `curl https://mise.run \| sh` | official install script |
| zoxide | `curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh \| sh` | official install script |

## direct, but not shell-script native

| tool | install path | reason |
| --- | --- | --- |
| ast-grep | `uv tool install ast-grep-cli` | upstream supports pip/npm/cargo/homebrew; uv keeps it direct and avoids brew |
| lazygit | github release tarball on linux, brew on macos | no official curl installer; release binary is clean on linux |

## package-manager tools

| tool | reason |
| --- | --- |
| autossh | os package is the sane source |
| bat | release binaries exist, but apt/brew are boring and reliable; ubuntu command name is `batcat`, handled by alias |
| btop | linux release binaries exist; package manager keeps gpu/platform quirks boring |
| delta | release binaries exist; package name differs (`git-delta`) but package manager is reliable |
| direnv | upstream docs are package-manager-first |
| eza | release binaries exist; package manager is simpler and current enough on ubuntu 24.04 |
| fd | release binaries exist; package manager is fine; ubuntu command name is `fdfind`, handled by alias/function |
| fzf | has a git install script, but it edits shell rc files; package manager is cleaner because dotfiles own shell integration |
| gh | official docs are package-manager/binary-release based |
| git | os package |
| jq | upstream provides standalone binaries; package manager is fine unless we need newest jq |
| ncdu | os package |
| ripgrep | release binaries/debs exist; package manager is fine on ubuntu 24.04 |
| shellcheck | package manager is fine for local linting |
| yq | standalone binary exists; package manager is fine unless we need latest yq |
| zsh | os package |
| zsh-autosuggestions | cloned as oh-my-zsh custom plugin |
| zsh-syntax-highlighting | cloned as oh-my-zsh custom plugin |
