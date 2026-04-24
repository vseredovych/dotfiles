# Ubuntu Setup Guide

Minimal setup guide for this dotfiles branch on Ubuntu 22.04+.

## 1. Install dependencies

```bash
bash scripts/install-dependencies.sh
```

This installs apt packages, oh-my-posh, and pyenv. Ghostty requires a manual .deb download (see script output).

## 2. Set zsh as default shell

```bash
chsh -s $(which zsh)
```

Log out and back in for the change to take effect.

## 3. Deploy dotfiles

```bash
bash deploy.sh
```

## 4. Start a new zsh session

On first launch, zinit will auto-install itself and all plugins. This takes ~30 seconds.

## 5. Clipboard

Clipboard aliases use `xclip`:

- `c` / `cc` — copy stdin to clipboard
- `v` — paste from clipboard

Requires an X11 session. If running Wayland, install `wl-clipboard` and switch to the Arch branch or adapt the aliases.

## 6. tmux-sessionizer

The `tmux-sessionizer` script lives at `~/.local/bin/tmux-sessionizer` (deployed by `deploy.sh`). Edit `~/.config/tmux-sessionizer/tmux-sessionizer.conf` to set your search paths.

Invoke with `Ctrl+F` (empty prompt) or `Ctrl+a f` inside tmux.
