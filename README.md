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

---

## Planned: nix-darwin + home-manager migration (macOS branch)

**Goal:** Replace the deployed `configs/.zshrc` dotfile with a fully declarative nix-darwin + home-manager setup. The nix-darwin config already lives in this repo at `configs/.config/nix-darwin/`.

### Target file structure

```
configs/.config/nix-darwin/
├── flake.nix     # inputs + wiring only
├── darwin.nix    # system-level config (packages, homebrew, launchd)
└── home.nix      # home-manager: zsh, aliases, plugins, env vars
```

### What changes

| Before | After |
|--------|-------|
| `configs/.zshrc` deployed by `deploy.sh` | Deleted — home-manager generates `~/.zshrc` |
| Zinit bootstraps plugins at runtime from GitHub | nixpkgs-pinned plugins via `programs.zsh.plugins` |
| `zinit snippet OMZP::*` | `programs.zsh.oh-my-zsh.plugins` |
| Aliases/env vars inline in zshrc | `programs.zsh.shellAliases` / `sessionVariables` |
| History `setopt` lines | `programs.zsh.history` block |

### Plugin mapping (zinit → nixpkgs)

| zinit | nixpkgs | Load order |
|---|---|---|
| zsh-users/zsh-autosuggestions | `pkgs.zsh-autosuggestions` | 1st |
| zsh-users/zsh-completions | `pkgs.zsh-completions` | 2nd |
| Aloxaf/fzf-tab | `pkgs.zsh-fzf-tab` | 3rd |
| zsh-users/zsh-syntax-highlighting | `pkgs.zsh-syntax-highlighting` | last (required) |

### What stays in `initContent` (can't be expressed structurally)

- `bindkey -e`, `edit-command-line` widget
- `zstyle` completion styling rules
- `eval "$(oh-my-posh init zsh ...)"` prompt
- `eval "$(fzf --zsh)"`, `eval "$(zoxide init zsh)"`
- `_ctrl_f` widget (Ctrl+F sessionizer), `yazi-launcher` widget (Ctrl+G)
- `z()` wrapper around zoxide, `iv()` kitty icat helper
- `eval -- "$(pyenv init --path)"`
- `[[ -f ~/.zshrc.work ]] && source ~/.zshrc.work`

### Key nix details

- `home-manager.useGlobalPkgs = true` + `useUserPackages = true` — single nixpkgs instance
- `nix.enable = false` (Determinate Nix) is compatible with home-manager — no conflict
- Zsh `${...}` expressions in `initContent` must be escaped as `''${...}` (e.g. `''${(s.:.)LS_COLORS}`)
- `specialArgs = { inherit self; }` passed to `darwinSystem` so `darwin.nix` can reference `self.rev`

### Activation

```bash
# dry-run first
darwin-rebuild build --flake ~/.config/nix-darwin

# apply
sudo darwin-rebuild switch --flake ~/.config/nix-darwin   # or: drs

# clean up old zinit after confirming everything works
rm -rf ~/.local/share/zinit
```
