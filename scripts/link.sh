#!/usr/bin/env bash
# Links shell-independent config. Shell config: scripts/zsh.sh or scripts/bash.sh.
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

echo "dotfiles: $DOTFILES_DIR"
echo

# $HOME
link "$DOTFILES_DIR/.vimrc" "$HOME_DIR/.vimrc"

# ~/.config
link "$DOTFILES_DIR/ghostty" "$HOME_DIR/.config/ghostty"
link "$DOTFILES_DIR/helix" "$HOME_DIR/.config/helix"
link "$DOTFILES_DIR/nvim" "$HOME_DIR/.config/nvim"
link "$DOTFILES_DIR/nix/nix.conf" "$HOME_DIR/.config/nix/nix.conf"
link "$DOTFILES_DIR/zed" "$HOME_DIR/.config/zed"

echo
echo "done."
