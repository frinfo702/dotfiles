#!/usr/bin/env bash
set -euo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_login_shell bash

# Only .bashrc: Ubuntu's ~/.profile already sources it for login shells.
link "$DOTFILES_DIR/bash/dotbashrc" "$HOME_DIR/.bashrc"
