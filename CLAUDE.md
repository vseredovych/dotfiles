# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for an Arch Linux system. All configs live under `configs/` (mirroring `~/`). Two scripts manage syncing:
- **`deploy.sh`** — copies `configs/` → `~/` (apply to live system)
- **`collect.sh`** — copies live `~/` → `configs/` (pull in live edits)

## Branches

| Branch  | Purpose |
|---------|---------|
| `main`  | Arch Linux (primary) |
| `macos` | macOS — shared configs adapted, no desktop WM layer |

To sync a shared config change to macOS:
```bash
git checkout macos
git checkout main -- configs/.zshrc   # or whichever file changed
# adjust macOS-specific lines if needed, then commit
```

## Conventions

- **Clipboard**: Arch/Wayland uses `wl-copy`/`wl-paste`; macOS branch uses `pbcopy`/`pbpaste` directly (no runtime conditionals — the branches diverge).
- **Consistent theme**: Catppuccin Mocha across all tools (terminal, editor, prompt, browser).
- **Rofi theme is static**: only the active theme (`launchers/type-4/style-5`, onedark colors) is tracked. `collect.sh` does not update rofi — edit the repo files directly if the theme changes.

## Key Config Locations

| Config | Path in repo |
|--------|-------------|
| Zsh | `configs/.zshrc` |
| Zsh profile (Hyprland autostart) | `configs/.zprofile` |
| Tmux | `configs/.tmux.conf` |
| Ghostty | `configs/.config/ghostty/config` |
| oh-my-posh | `configs/.config/ohmyposh/` |
| Hyprland WM | `configs/.config/hypr/hyprland.conf` |
| Hyprlock | `configs/.config/hypr/hyprlock.conf` |
| Hyprpaper | `configs/.config/hypr/hyprpaper.conf` |
| Rofi (active theme only) | `configs/.config/rofi/` |
| Waybar | `configs/.config/waybar/` |

## Architecture

- **Shell**: Zsh + Zinit plugin manager, with fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting
- **Prompt**: oh-my-posh (catppuccin-mocha theme from `configs/.config/ohmyposh/`)
- **Terminal**: Ghostty
- **Multiplexer**: Tmux with `Ctrl+a` prefix, vi-mode copy, F1-F9 window switching
- **WM**: Hyprland (Wayland) — Arch only

## Package Management

System uses `pacman` + `yay` (AUR). See `scripts/install-dependencies.sh` for the package list.
