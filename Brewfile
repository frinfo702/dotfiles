# mac only: what nix doesn't cover (GUI apps, tap-only tools, system-ish packages).
# CLI tools live in flake.nix.
#   brew bundle                 # install what's listed
#   brew bundle cleanup --force # uninstall what isn't

tap "anomalyco/tap"
tap "can1357/tap"
tap "coursier/formulas"
tap "frinfo702/rexdiff", "https://github.com/frinfo702/rexdiff", trusted: true

brew "anomalyco/tap/opencode-v2"
brew "can1357/tap/omp"
brew "azure-cli" # broken in nixpkgs (python fabric) as of 2026-10
brew "coursier/formulas/coursier" # scala/metals
brew "hf"
brew "openvpn"
brew "llvm"

cask "font-symbols-only-nerd-font"
cask "frinfo702/rexdiff/rexdiff"
cask "gcloud-cli"
cask "openlogi"
