#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_login_shell zsh

link "$DOTFILES_DIR/zsh/dotzshrc" "$HOME_DIR/.zshrc"
link "$DOTFILES_DIR/zsh/dotzshenv" "$HOME_DIR/.zshenv"
