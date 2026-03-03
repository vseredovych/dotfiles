# dotfiles

Personal dotfiles for Arch Linux + Hyprland (Wayland).

## Requirements

| Tool | Purpose |
|------|---------|
| Arch Linux | OS |
| [Hyprland](https://hyprland.org/) | Wayland compositor |
| Zsh + [Zinit](https://github.com/zdharma-continuum/zinit) | Shell + plugin manager |
| [oh-my-posh](https://ohmyposh.dev/) | Prompt |
| [Ghostty](https://ghostty.org/) | Primary terminal |
| Tmux | Terminal multiplexer |
| [Waybar](https://github.com/Alexays/Waybar) | Status bar |
| [Rofi](https://github.com/lbonn/rofi) | App launcher (Wayland fork) |
| Hyprpaper + Hyprlock | Wallpaper + screen lock |
| wl-clipboard | Clipboard (`wl-copy` / `wl-paste`) |

## Structure

```
configs/              # Mirrors ~/; all tracked configs live here
  .zshrc
  .tmux.conf
  .config/
    ghostty/
    ohmyposh/
    hypr/             # hyprland.conf, hyprlock.conf, hyprpaper.conf
    rofi/
    waybar/
scripts/
  tmux-start.sh       # Tmux session bootstrap
deploy.sh             # Copy configs/ → ~/  (apply to live system)
collect.sh            # Copy ~/  → configs/ (pull in live edits)
```

## Usage

**Install dotfile dependencies** (tools the configs depend on, not Hyprland itself):
```bash
./scripts/install-dependencies.sh
```

**Apply configs to the system:**
```bash
./deploy.sh
```

**Pull live edits back into the repo:**
```bash
./collect.sh
git diff configs/
```

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

## Arch Setup

Package installation and system setup instructions: [docs/arch-setup.md](docs/arch-setup.md).
