#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME}"

link() {
  local src="$1"
  local dest="$2"

  if [[ ! -e "$src" ]]; then
    echo "skip (missing): $src"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest")"
    if [[ "$current" == "$src" ]]; then
      echo "ok: $dest"
      return 0
    fi
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$backup"
    echo "backed up: $dest -> $backup"
  fi

  ln -s "$src" "$dest"
  echo "linked: $dest -> $src"
}

main() {
  echo "dotfiles: $DOTFILES_DIR"
  echo

  # $HOME
  link "$DOTFILES_DIR/cline" "$HOME_DIR/.cline"
  link "$DOTFILES_DIR/codex" "$HOME_DIR/.codex"
  link "$DOTFILES_DIR/cursor" "$HOME_DIR/.cursor"
  link "$DOTFILES_DIR/grok" "$HOME_DIR/.grok"
  link "$DOTFILES_DIR/.vimrc" "$HOME_DIR/.vimrc"

  # ~/.config
  link "$DOTFILES_DIR/ghostty" "$HOME_DIR/.config/ghostty"
  link "$DOTFILES_DIR/helix" "$HOME_DIR/.config/helix"
  link "$DOTFILES_DIR/nvim" "$HOME_DIR/.config/nvim"
  link "$DOTFILES_DIR/opencode" "$HOME_DIR/.config/opencode"

  # VS Code (macOS)
  if [[ "$(uname -s)" == "Darwin" ]]; then
    local vscode_user="$HOME_DIR/Library/Application Support/Code/User"
    link "$DOTFILES_DIR/vscode/setting.json" "$vscode_user/settings.json"
    link "$DOTFILES_DIR/vscode/keybinding.json" "$vscode_user/keybindings.json"
  fi

  echo
  echo "done."
}

main "$@"
