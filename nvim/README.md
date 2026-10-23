# nvim

Neovim 0.12+。helix の体験（テーマ・LSP・UI・キー）を移植した構成。

## 設定はどこにあるか

| 何を | どこで |
| --- | --- |
| 普段の設定（テーマ、行番号、フォーマット、LSPのon/off など） | `:Settings`（`<space>,`）→ `settings.json` に保存 |
| プロジェクト固有の設定 | `:Settings` で `<Tab>` → `<project>/.nvim/settings.json` |
| 設定項目とデフォルト値 | `lua/config/settings.lua` |
| プラグイン | `lua/config/plugins.lua`（バージョンは `nvim-pack-lock.json`） |
| LSP サーバーごとの設定 | `lsp/<name>.lua` |
| キーマップ | `lua/config/keymaps.lua` |

`settings.json` はデフォルトとの差分だけを持つので、`git diff` を見れば何を変えたか分かります。
これ以外の場所に状態は残りません（Mason なし、`vim.pack` が宣言にないプラグインをディスクから消す）。

## LSP

プロジェクト優先で解決します。

- バイナリ: `<root>/node_modules/.bin` → `<root>/.venv/bin` → `<root>/venv/bin` → `$PATH`
- 設定: lspconfig のデフォルト < `lsp/<name>.lua` < `settings.json` の `lsp.config` < `.nvim/settings.json` の `lsp.config`

グローバルなサーバーは dotfiles の `flake.nix` で管理しています（`~/.nix-profile/bin` に入る）。

```sh
nix profile install .#lsp                        # 初回（dotfiles のルートで）
nix flake update && nix profile upgrade lsp      # 更新
```

プロジェクト専用のサーバーは、そのプロジェクトの devShell に入れて direnv の `use flake` で読み込めば、PATH の先頭に来るのでグローバルより優先されます。
`:Settings` の LSP 欄で、各サーバーがどこから見つかったか (✓ パス / ✗) を確認できます。

```json
// <project>/.nvim/settings.json の例
{
  "lsp": {
    "servers": { "pyright": false, "basedpyright": true },
    "config": { "basedpyright": { "settings": { "basedpyright": { "analysis": { "typeCheckingMode": "strict" } } } } }
  },
  "format": { "by_ft": { "python": ["black"] } }
}
```

プロジェクトのファイルは初回に信頼するか聞かれます（`vim.secure`）。

## テーマ

`colors/*.lua` は `helix/themes/*.toml` から生成しています。helix 側を編集したら再生成してください。

```sh
python3 nvim/scripts/helix2nvim.py
```

## プラグイン

- 更新: `:lua vim.pack.update()`（差分を確認して `:write` で適用）
- 追加/削除: `lua/config/plugins.lua` を編集して再起動

## キー（helix の space モード相当）

`<space>f` ファイル / `b` バッファ / `/` grep / `s` `S` シンボル / `d` `D` 診断 / `a` コードアクション / `r` リネーム / `k` ホバー / `e` エクスプローラ / `'` 直前のピッカー / `?` コマンド / `F` フォーマット / `,` 設定

`gd` `gD` `gy` `gi` `gr` 定義などへ移動、`gl` 診断フロート、`<A-j>` `<A-k>` 行移動、`<space>gg` lazygit、`<space>gd` lazydocker
