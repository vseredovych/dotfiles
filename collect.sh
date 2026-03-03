#!/bin/bash
# collect.sh — copy live configs from ~/ back into repo
set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

collect() {
    local src="$HOME/$1" dst="$DOTFILES/configs/$1"
    if [[ -e "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp -rv "$src" "$dst"
    else
        echo "SKIP (not found): $src"
    fi
}

collect .zshrc
collect .zprofile
collect .tmux.conf
collect .config/ghostty
collect .config/ohmyposh
collect .config/hypr
collect .config/rofi
collect .config/waybar
echo "Done. Review with: git diff configs/"
