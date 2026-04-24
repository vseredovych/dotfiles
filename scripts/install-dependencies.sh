#!/bin/bash
# install-dependencies.sh — Install tools required by these dotfiles.
# Targets Ubuntu 22.04+.
# Run: bash scripts/install-dependencies.sh

set -e

APT_PKGS=(
    zsh             # shell
    tmux            # terminal multiplexer
    neovim          # editor (aliased as vim)
    fzf             # fuzzy finder (zsh integration + fzf-tab)
    zoxide          # frecency-based directory jumping (z command)
    xclip           # clipboard (c/v aliases, tmux copy-pipe)
    git             # required for zinit auto-install
)

echo "==> Installing apt packages..."
sudo apt-get update
sudo apt-get install -y "${APT_PKGS[@]}"

echo ""
echo "==> Installing oh-my-posh..."
curl -s https://ohmyposh.dev/install.sh | bash -s

echo ""
echo "==> Installing pyenv..."
curl https://pyenv.run | bash

echo ""
echo "==> Installing ghostty..."
echo "    Download the latest .deb from https://ghostty.org/download and run:"
echo "    sudo dpkg -i ghostty_*.deb"

echo ""
echo "==> Manual steps:"
echo ""
echo "  zinit       — installs itself on first zsh launch (no action needed)"
echo "  zsh default — run: chsh -s \$(which zsh)"
echo ""
echo "Done. Start a new zsh session to finish setup."
