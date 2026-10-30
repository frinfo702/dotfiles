{
  description = "dotfiles: CLI tools for mac and ubuntu";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    # Prebuilt Rex. Pre-release: needs the token in the netrc that nix/nix.conf includes.
    rex.url = "https://pkgs.superlogical.com/rex/nix/preview.tar.gz";
  };

  # Install:  nix profile install .#cli
  # Update:   nix flake update && nix profile upgrade cli
  # Add/remove a tool: edit the lists below, then `nix profile upgrade cli`.
  #
  # Not here on purpose:
  #   - GUI apps, tap-only tools (mac)      -> Brewfile
  #   - GPU drivers / CUDA / nvtop (ubuntu) -> apt (nix binaries can't see the host's libcuda)
  #   - python envs, torch                  -> uv
  #   - the toolchains themselves (rust, node, python, jdk) -> rustup / fnm / uv / mise, installed from here
  #   - local builds and crates not in nixpkgs (hxr, cargo-compete) -> cargo install
  #   - fast-moving AI CLIs                 -> their own installers
  #
  # Rex alone (linux):  nix profile add .#rex
  # Update Rex:         nix flake update rex && nix profile upgrade rex
  outputs =
    { nixpkgs, rex, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      packages = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = p: builtins.elem (nixpkgs.lib.getName p) [ "terraform" ];
          };

          shared = with pkgs; [
            # shell / files
            git
            gh
            ghq
            delta
            direnv
            nix-direnv
            fzf
            fd
            ripgrep
            jq
            tree
            lsd
            yazi
            zoxide
            tmux
            btop
            wget
            _7zz
            zsh-syntax-highlighting
            # editors / git UIs
            neovim
            helix
            tree-sitter
            lazygit
            lazydocker
            hunk
            herdr
            jujutsu
            zellij
            lumen
            # languages / build
            uv
            fnm
            go
            rustup # toolchains stay per-project via rust-toolchain.toml
            cargo-watch
            cargo-edit
            cmake
            sbt
            ammonite
            jbang
            # docs / media
            typst
            hugo
            marp-cli
            graphviz
            imagemagick
            ffmpeg-full
            poppler-utils
            resvg
            yt-dlp
            figlet
            # infra / cloud
            terraform
            k9s
            wrangler
            mongodb-atlas-cli
            mongodb-tools
            mongosh
            redis
            sshuttle
            # formatters
            prettier
            mdformat
            shfmt
            stylua
          ];

          # language servers used by nvim (see nvim/lua/config/settings.lua)
          lsp = with pkgs; [
            pyright
            basedpyright
            ruff
            typescript-language-server
            biome
            gopls
            golangci-lint-langserver
            golangci-lint
            clang-tools
            lua-language-server
            tinymist
            dockerfile-language-server
            docker-compose-language-service
            bash-language-server
            taplo
            yaml-language-server
            vscode-langservers-extracted
            marksman
            terraform-ls
            zls
            jdt-language-server
          ];

          darwin = with pkgs; [ xcodegen ];

          linux = [ rex.packages.${system}.rex ];

          cli = pkgs.buildEnv {
            name = "cli";
            paths = shared ++ lsp ++ (if pkgs.stdenv.hostPlatform.isDarwin then darwin else linux);
          };
        in
        {
          inherit cli;
          default = cli;
          rex = rex.packages.${system}.rex;
        }
      );
    };
}
