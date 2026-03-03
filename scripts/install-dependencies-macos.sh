#!/bin/bash
# install-dependencies-macos.sh — Install tools required by these dotfiles on macOS.
# Assumes Homebrew is already installed (https://brew.sh).
# Run: bash scripts/install-dependencies-macos.sh

set -e

BREW_PKGS=(
    tmux            # terminal multiplexer
    neovim          # editor (aliased as vim)
    fzf             # fuzzy finder (zsh integration + fzf-tab)
    zoxide          # frecency-based directory jumping (z command)
    oh-my-posh      # prompt (eval in .zshrc)
    pyenv           # Python version manager (eval in .zshrc)
    ripgrep         # fast grep (rg)
    # Note: wl-clipboard is Linux-only; pbcopy/pbpaste are built-in on macOS
    # Note: playerctl, brightnessctl, pavucontrol, dolphin are Linux/Wayland-only
)

BREW_CASKS=(
    ghostty         # terminal emulator
)

echo "==> Installing brew packages..."
brew install "${BREW_PKGS[@]}"

echo ""
echo "==> Installing brew casks..."
brew install --cask "${BREW_CASKS[@]}"

echo ""
echo "==> Manual steps:"
echo ""
echo "  zinit — installs itself on first zsh launch (no action needed)"
echo ""
echo "Done. Start a new zsh session to finish setup."
