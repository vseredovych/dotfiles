# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for an Arch Linux system. All configs live under `configs/` (mirroring `~/`). Two scripts manage syncing:
- **`deploy.sh`** — copies `configs/` → `~/` (apply to live system)
- **`collect.sh`** — copies live `~/` → `configs/` (pull in live edits)

## Conventions

- **Wayland migration in progress**: newer configs use `wl-copy`/`wl-paste` (Wayland) instead of `xclip` (X11).
- **Consistent theme**: Catppuccin Mocha across all tools (terminal, editor, prompt, browser).

## Key Config Locations

| Config | Path in repo |
|--------|-------------|
| Zsh | `configs/.zshrc` |
| Tmux | `configs/.tmux.conf` |
| Ghostty | `configs/.config/ghostty/config` |
| i3 | `configs/.config/i3/config` |
| oh-my-posh | `configs/.config/ohmyposh/` |
| Firefox CSS | `configs/.firefox/chrome/userChrome.css` |
| VS Code | `configs/.vscode/` |
| Tmux session script | `scripts/tmux-start.sh` |

## Architecture

- **Shell**: Zsh + Zinit plugin manager, with fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting
- **Prompt**: oh-my-posh (catppuccin-mocha theme from `configs/.config/ohmyposh/`)
- **Terminal**: Ghostty (primary), Alacritty (secondary)
- **Multiplexer**: Tmux with `Ctrl+a` prefix, vi-mode copy, F1-F9 window switching
- **WM**: i3 with hjkl navigation, dual-monitor layout (HDMI-1-0 primary, eDP-1 secondary)
- **Editor**: VS Code (settings and keybindings in `configs/.vscode/`)

## Package Management

System uses `pacman` + `yay` (AUR). See `README.md` for categorized package installation commands.
