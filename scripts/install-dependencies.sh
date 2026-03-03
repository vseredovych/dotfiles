#!/bin/bash
# install-deps.sh — Install tools required by these dotfiles.
# Assumes Arch Linux with Hyprland already set up.
# Run: bash scripts/install-deps.sh

set -e

PACMAN_PKGS=(
    zsh             # shell
    tmux            # terminal multiplexer
    neovim          # editor (aliased as vim)
    fzf             # fuzzy finder (zsh integration + fzf-tab)
    zoxide          # frecency-based directory jumping (z command)
    wl-clipboard    # wl-copy / wl-paste (clipboard aliases, tmux copy-pipe)
    brightnessctl   # screen brightness keys
    playerctl       # media keys (play/pause/next/prev)
    pavucontrol     # audio control (waybar pulseaudio on-click)
    dolphin         # file manager ($fileManager in hyprland)
)

AUR_PKGS=(
    ghostty         # terminal emulator
    oh-my-posh-bin  # prompt (eval in .zshrc)
    pyenv           # Python version manager (eval in .zshrc)
    hyprshot        # screenshot tool (Super+S binds)
    wshowkeys       # on-screen key display (Super+K bind)
)

echo "==> Installing pacman packages..."
sudo pacman -S --needed "${PACMAN_PKGS[@]}"

echo ""
echo "==> Installing AUR packages (requires yay)..."
yay -S --needed "${AUR_PKGS[@]}"

echo ""
echo "==> Manual steps:"
echo ""
echo "  zinit — installs itself on first zsh launch (no action needed)"
echo ""
echo "Done. Start a new zsh session to finish setup."
