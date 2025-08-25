" デフォルトの.vimrc設定

" 基本設定
set nocompatible              " Vi互換モードを無効にする
set backspace=indent,eol,start " バックスペースキーの動作を改善
set history=1000              " コマンド履歴の保存数を増やす

" 表示設定
syntax on                     " シンタックスハイライトを有効にする
set number                    " 行番号を表示する
set showcmd                   " コマンドを表示する
set cursorline                " カーソル行をハイライトする

" 検索設定
set hlsearch                  " 検索結果をハイライトする
set incsearch                 " インクリメンタルサーチを有効にする
set ignorecase                " 大文字小文字を無視して検索する
set smartcase                 " 大文字を含む場合は大文字小文字を区別する

" インデント設定
set autoindent                " 自動インデントを有効にする
set smartindent               " スマートインデントを有効にする
set tabstop=4                 " タブ幅を4に設定する
set shiftwidth=4              " 自動インデントの幅を4に設定する
set expandtab                 " タブをスペースに変換する

" ファイル設定
set encoding=utf-8            " ファイルエンコーディングをUTF-8に設定する
set fileencoding=utf-8        " ファイルエンコーディングをUTF-8に設定する
set fileformats=unix,dos,mac  " ファイルフォーマットを設定する

" カスタムマッピング
inoremap jk <Esc>

" カーソルの形状をモードによって変更
if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif
