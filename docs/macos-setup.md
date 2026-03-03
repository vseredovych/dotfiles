# macOS Setup

Setup guide for the `macos` branch of these dotfiles.

## 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the post-install instructions to add Homebrew to your PATH (printed at the end of the installer).

## 2. Install dependencies

```bash
bash scripts/install-dependencies-macos.sh
```

This installs: tmux, neovim, fzf, zoxide, oh-my-posh, pyenv, ripgrep, and the Ghostty terminal cask.

## 3. Deploy dotfiles

```bash
./deploy.sh
```

This copies `configs/` → `~/`. Zsh is already the default shell on macOS 10.15+.

## 4. Clone Neovim config

```bash
git clone <your-nvim-config-repo> ~/.config/nvim
```

## 5. Start a new shell

Open a new terminal (or Ghostty) and Zinit will auto-install on first launch.
