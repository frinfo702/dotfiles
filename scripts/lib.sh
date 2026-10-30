# Sourced by the scripts in this directory.

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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

# Stop unless the login shell is $1, so a machine only gets one shell's config.
# Switch with `chsh -s "$(command -v zsh)"`, log in again, then run the script.
require_login_shell() {
  local want="$1"
  local have="${SHELL##*/}"
  if [[ "$have" != "$want" ]]; then
    echo "login shell is $have, not $want: skipping (run scripts/$have.sh instead)" >&2
    exit 1
  fi
}
