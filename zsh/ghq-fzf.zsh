# ghq で管理しているリポジトリを fzf で fuzzy 検索して移動
function ghq-fzf() {
    local src
    src=$(ghq list --full-path | fzf --preview 'ls -laTp {}')
    if [ -n "$src" ]; then
        cd "$src"
    fi
}

# Ctrl+G で ghq-fzf を呼び出す zle ウィジェット
function _ghq-fzf-widget() {
    ghq-fzf
    zle reset-prompt
}
zle -N _ghq-fzf-widget
bindkey '^g' _ghq-fzf-widget
