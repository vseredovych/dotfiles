# Arch Linux System Setup Guide

Instructions for setting up an Arch Linux system with the required packages, organized by category. Packages are installed using `pacman` (official repos) and `yay` (AUR).

## Prerequisites

1. **Arch Linux Installation**: Ensure you have a working Arch Linux system.
2. **Internet Connection**: Required for downloading packages.
3. **sudo Privileges**: Most commands require `sudo` for system-wide installation.
4. **Update System**: Start by updating your system:
   ```bash
   sudo pacman -Syyu
   ```

## Step 1: Install and Configure Package Managers

### Pacman

`pacman` is pre-installed. Keep it up-to-date via `sudo pacman -Syyu`.

### Yay (AUR Helper)

```bash
sudo pacman -S base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Step 2: Install Packages by Category

### Development Tools

```bash
sudo pacman -S neovim luarocks python3-pip python-pip pyenv libxml2 curl zlib nss
```

- **neovim**: Advanced text editor with plugin support.
- **luarocks**: Lua package manager (required for Neovim plugins).
- **python3-pip, python-pip**: Python package managers.
- **pyenv**: Manage multiple Python versions.
- **libxml2, curl, zlib, nss**: Libraries for development tasks.

### System Monitoring and Management

```bash
sudo pacman -S htop btop fzf reflector
```

- **htop, btop**: System monitors for processes and resources.
- **fzf**: Fuzzy finder for efficient searching.
- **reflector**: Manages Arch Linux mirror lists.

### Networking Tools

```bash
sudo pacman -S netcat nmap wget ca-certificates ca-certificates-utils
```

- **netcat**: Networking utility (also installed as `nc`).
- **nmap**: Network exploration and security scanning.
- **wget**: File download tool.
- **ca-certificates, ca-certificates-utils**: Certificates for secure connections.

### VPN and Network Management

```bash
sudo pacman -S openconnect networkmanager-openconnect nm-connection-editor
```

- **openconnect**: VPN client for Cisco AnyConnect and others.
- **networkmanager-openconnect**: NetworkManager plugin for VPN.
- **nm-connection-editor**: GUI for NetworkManager.

### Web and Browser Dependencies

```bash
sudo pacman -S webkit2gtk webkit2gtk-4.1 webkit2gtk-4.1-docs
```

- **webkit2gtk, webkit2gtk-4.1, webkit2gtk-4.1-docs**: Web content engine and documentation.

Install Zen Browser:

```bash
yay -S zen-browser-bin
```

### Audio Utilities

```bash
sudo pacman -S alsa-utils pavucontrol bsdtar ardelay
```

- **alsa-utils**: ALSA tools (includes `aplay`).
- **pavucontrol**: PulseAudio volume control.
- **bsdtar**: BSD tar for archiving.
- **ardelay**: Audio delay utility.

### Productivity Applications

```bash
sudo pacman -S libreoffice-still obsidian
yay -S teams-for-linux mongodb-compass-bin
```

- **libreoffice-still**: Stable office suite.
- **obsidian**: Note-taking application.
- **teams-for-linux**: Microsoft Teams client.
- **mongodb-compass-bin**: MongoDB GUI.

### Terminal and Shell Utilities

```bash
sudo pacman -S tmux
yay -S ripgrep
```

- **tmux**: Terminal multiplexer.
- **ripgrep**: Fast recursive search.

### Desktop and Window Management

```bash
sudo pacman -S hyprlock hyprpaper waybar rofi wl-clipboard
```

- **hyprlock**: Screen locker for Hyprland.
- **hyprpaper**: Wallpaper utility for Hyprland.
- **waybar**: Status bar.
- **rofi**: App launcher (use the Wayland fork).
- **wl-clipboard**: Wayland clipboard utilities.

## Step 3: Post-Installation

1. **Deploy dotfiles**:
   ```bash
   ./deploy.sh
   ```

2. **Clean up cached packages**:
   ```bash
   sudo pacman -Sc
   yay -Sc
   ```

## Notes

- Run `sudo pacman -Syyu` periodically to keep your system updated.
