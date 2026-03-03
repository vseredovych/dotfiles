#!/bin/bash
# collect.sh — copy live configs from ~/ back into repo
set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

collect() {
    local src="$HOME/$1" dst="$DOTFILES/configs/$1"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        cp -rv "$src/." "$dst/"
    elif [[ -f "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp -v "$src" "$dst"
    else
        echo "SKIP (not found): $src"
    fi
}

collect .zshrc
collect .tmux.conf
collect .config/ghostty
collect .config/ohmyposh
echo "Done. Review with: git diff configs/"
