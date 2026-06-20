# dotfiles

central home-directory setup managed with chezmoi. the repo is the source of truth; the home directory is the rendered output.

## mental model

chezmoi maps files like this:

```text
dot_zshrc.tmpl              -> ~/.zshrc
dot_gitconfig.tmpl          -> ~/.gitconfig
dot_config/git/ignore       -> ~/.config/git/ignore
dot_config/dotfiles/shell   -> ~/.config/dotfiles/shell
```

templates can branch on os, hostname, home dir, and 1password values. this is why we use chezmoi instead of raw symlinks: macos and linux can share one repo without pretending their paths and tools are identical.

normal loop:

```sh
chezmoi diff
chezmoi apply
./scripts/doctor
```

`chezmoi diff` is the safety check. it shows what would change in `~`. `chezmoi apply` mutates `~`.

## bootstrap

from this checkout:

```sh
./scripts/bootstrap
chezmoi init --source "$PWD"
chezmoi diff
chezmoi apply
```

fresh-machine shape:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ischemist/dotfiles
chezmoi cd
./scripts/bootstrap
chezmoi apply
```

dependency policy lives in:

```text
docs/dependencies.md
```

the short version: use direct upstream installers when the tool has a good one, and use brew/apt only for boring system packages or tools whose direct story is worse.

## shell layout

entrypoints:

```text
~/.zshrc
~/.bashrc
~/.profile
~/.zprofile
~/.zshenv
```

shared modules:

```text
~/.config/dotfiles/shell/common.sh
~/.config/dotfiles/shell/path.sh
~/.config/dotfiles/shell/aliases.sh
~/.config/dotfiles/shell/functions.sh
~/.config/dotfiles/shell/zsh.zsh
~/.config/dotfiles/shell/bash.sh
```

the shell files are guarded so missing optional tools should not break startup.

## prompt

prompt is starship.

customizations:

- aws module disabled globally because a default aws region is not useful repo context
- branch color is stateful:
  - main/master clean: red
  - main/master dirty: deeper red
  - topic clean: green
  - topic dirty: orange
- built-in git status symbols are kept:
  - `?` untracked
  - `!` modified
  - `+` staged
  - `$` stashed
  - `=` conflicted

config:

```text
~/.config/starship.toml
```

## history

history is atuin.

bindings:

```text
up arrow  -> atuin search
ctrl-r    -> atuin search
enter     -> insert selected command
tab       -> insert selected command
```

config:

```text
~/.config/atuin/config.toml
```

important settings:

```toml
enter_accept = false
filter_mode = "global"
filter_mode_shell_up_key_binding = "workspace"
workspaces = true
```

this means ordinary searches are global, but up-arrow prefers commands from the current git workspace. old imported zsh history may have `cwd=unknown`, so workspace mode becomes most useful for commands recorded after atuin was installed.

sync:

```sh
atuin register -u "$USER"
atuin key
atuin sync
```

on the next machine:

```sh
atuin login -u "$USER" -k "<atuin encryption key>"
atuin sync
```

the atuin encryption key is the thing to store in 1password. without it, the server has encrypted history it cannot read and the new machine cannot decrypt.

`per-directory-history` is intentionally not used. atuin already has directory/workspace/session/global filters, and the old zsh plugin conflicts with atuin recording.

## file listing

`eza` replaces `ls` when installed.

aliases:

```sh
ls  -> eza --icons=auto --group-directories-first
ll  -> eza -lah --icons=auto --git --group-directories-first
la  -> eza -la --icons=auto --group-directories-first
lt  -> eza --tree --level=2 --icons=auto --group-directories-first
```

icons need a nerd-font-compatible terminal font.

## fuzzy finding

`fzf` is installed for interactive fuzzy selection.

zsh/bash load the official fzf completion and key bindings when available.

useful defaults:

```text
ctrl-t  fuzzy select files into the command line
alt-c   fuzzy cd
```

atuin owns history search, so fzf is mostly for files, dirs, branches, and ad hoc scripting.

## navigation

`zoxide` replaces manual `cd` muscle memory with frecency-based jumping.

example:

```sh
z procrustes
z synth
```

`cdd` fuzzy-selects a directory below the current directory and `cd`s into it.

```sh
cdd
cdd crustes
```

the optional argument seeds the fzf query; press enter to accept the selected directory.

## git

git config uses ssh signing and delta.

ssh commit signing uses yubikey-backed `ed25519-sk` keys:

```ini
[user]
  signingkey = ~/.ssh/github/sign-primary-notouch.pub
[gpg]
  format = ssh
[gpg "ssh"]
  allowedSignersFile = ~/.config/git/allowed_signers
[commit]
  gpgsign = true
```

the signing keys are no-touch keys. this is intentional for commit signing only: the yubikey must still be present, but commits do not require a pin or touch prompt. do not reuse this policy for ssh auth keys.

delta is the git pager:

```ini
[core]
  pager = delta
[interactive]
  diffFilter = delta --color-only
[delta]
  navigate = true
  side-by-side = true
  line-numbers = true
```

`lazygit` is installed and aliased:

```sh
lg
```

use lazygit for staging hunks, browsing repo state, stash/log/rebase work, and quick visual inspection. use normal git cli for scripted or exact commands.

global gitignore lives at:

```text
~/.config/git/ignore
```

## json and cli plumbing

`jq` is the json scalpel. keep it close.

examples:

```sh
gh pr view --json title,url | jq .
curl ... | jq '.items[] | .name'
```

`yq` is the yaml/toml/xml-ish companion.

`ripgrep` and `fd` are the fast search/find defaults.

```sh
rg "needle"
fd pyproject
```

`bat` is for readable file previews.

## versions and environments

`mise` is the runtime/tool version manager.

`direnv` loads per-directory env state from `.envrc`.

`uv` is the python package/project runner.

the prompt is configured to show relevant runtime context through starship’s default language modules.

## remote and tunnels

`autossh` is installed, with a helper:

```sh
tunnel -L 5433:localhost:5432 mybox
```

this runs a persistent ssh tunnel:

```sh
autossh -M 0 -N \
  -o serveraliveinterval=30 \
  -o serveralivecountmax=3 \
  ...
```

## structural search

`ast-grep` is part of the default stack as `sg`.

repo-local helper:

```sh
sg-dotfiles
```

current rules catch:

- hardcoded `/Users/morgunov` in managed shell files
- token-like exports in shell files

this is for syntax-aware config hygiene, not dependency analysis.

## 1password

`op` is supported by chezmoi config and expected to be available on personal machines.

rules:

- do not commit 1password state, auth dbs, or generated credential files
- prefer `op run` / secret references for runtime env
- use chezmoi 1password template reads sparingly, only when a secret truly needs to render into a file

## terminal

ghostty config is managed on macos:

```text
~/Library/Application Support/com.mitchellh.ghostty/config
```

the managed config keeps the actual settings and drops the generated comments.

## packages

macos packages:

```text
Brewfile
```

ubuntu-ish package list:

```text
packages/ubuntu.txt
```

some modern cli names vary by distro. bootstrap installs what the package manager can provide and reports missing packages.

## verification

run:

```sh
./scripts/doctor
```

checks:

- bash syntax
- zsh syntax
- shellcheck when installed
- ast-grep rules
- chezmoi source parse
- simple secret audit

## guardrails

- do not track `~/.ssh`, `~/.aws/credentials`, `~/.config/gh/hosts.yml`, `rclone.conf`, auth dbs, or history dbs
- do not put plaintext tokens in shell files
- avoid shell startup network calls
- keep integrations guarded with `command -v`
- prefer workspace-aware tools over per-directory hacks
