# Arch Linux System Setup Guide

This README provides instructions for setting up an Arch Linux system with the required packages, organized by category. The packages are installed using `pacman` (for official Arch repositories) and `yay` (for Arch User Repository, AUR). Follow the steps below to replicate the system configuration.

## Prerequisites

1. **Arch Linux Installation**: Ensure you have a working Arch Linux system.
2. **Internet Connection**: Required for downloading packages.
3. **sudo Privileges**: Most commands require `sudo` for system-wide installation.
4. **Update System**: Start by updating your system to ensure you have the latest package database:
   ```bash
   sudo pacman -Syyu
   ```

## Step 1: Install and Configure Package Managers

### Pacman
`pacman` is the default package manager for Arch Linux and is pre-installed. Ensure it’s up-to-date:
```bash
sudo pacman -S pacman
```

### Yay (AUR Helper)
`yay` is used for installing packages from the AUR. To install `yay`:
1. Install dependencies:
   ```bash
   sudo pacman -S base-devel git
   ```
2. Clone and build `yay`:
   ```bash
   git clone https://aur.archlinux.org/yay.git
   cd yay
   makepkg -si
   ```
3. Verify `yay` installation:
   ```bash
   yay --version
   ```

## Step 2: Install Packages by Category

### Development Tools
These tools are essential for coding, scripting, and managing development environments.

```bash
sudo pacman -S neovim luarocks python3-pip python-pip pyenv libxml2 curl zlib nss
```

- **neovim**: Advanced text editor with plugin support.
- **luarocks**: Lua package manager (required for Neovim)
- **python3-pip, python-pip**: Python package managers.
- **pyenv**: Manage multiple Python versions.
- **libxml2, curl, zlib, nss**: Libraries for development tasks.

### System Monitoring and Management
Tools for monitoring system resources and managing configurations.

```bash
sudo pacman -S htop btop fzf reflector
yay -S btop
```

- **htop, btop**: System monitors for processes and resources.
- **fzf**: Fuzzy finder for efficient searching.
- **reflector**: Manages Arch Linux mirror lists.

### Networking Tools
Utilities for network diagnostics and file downloads.

```bash
sudo pacman -S netcat nmap wget ca-certificates ca-certificates-utils
```

- **netcat**: Networking utility (also installed as `nc`).
- **nmap**: Network exploration and security scanning.
- **wget**: File download tool.
- **ca-certificates, ca-certificates-utils**: Certificates for secure connections.

### VPN and Network Management
Packages for VPN connectivity and network configuration.

```bash
sudo pacman -S openconnect networkmanager-openconnect nm-connection-editor
```
- **openconnect**: VPN client for Cisco AnyConnect and others.
- **networkmanager-openconnect**: NetworkManager plugins for VPN.
- **nm-connection-editor**: GUI for network manager.

### Web and Browser Dependencies
Dependencies for web-based applications.

```bash
sudo pacman -S webkit2gtk webkit2gtk-4.1 webkit2gtk-4.1-docs
```

- **webkit2gtk, webkit2gtk-4.1, webkit2gtk-4.1-docs**: Web content engine and documentation (Don't remember why I need that)

Install Zen Browser

- **zen-browser-bin**: Zen browser
```bash
sudo pacman -S zen-browser-bin
```

### Audio Utilities
Tools for managing audio output and settings.

```bash
sudo pacman -S alsa-utils pavucontrol bsdtar ardelay
```

- **alsa-utils**: ALSA tools (includes `aplay`).
- **pavucontrol**: PulseAudio volume control.
- **bsdtar**: BSD tar for archiving.
- **ardelay**: Audio delay utility.

### Productivity Applications
Applications for office work, note-taking, and communication.

```bash
sudo pacman -S libreoffice-still obsidian teams-for-linux
yay -S teams-for-linux mongodb-compass-bin
```

- **libreoffice-still**: Stable office suite.
- **obsidian**: Note-taking application.
- **teams-for-linux**: Microsoft Teams client.
- **mongodb-compass-bin**: MongoDB GUI tools.

### Terminal and Shell Utilities
Utilities for enhancing terminal workflows.

```bash
sudo pacman -S tmux
yay -S ripgrep
```

- **tmux**: Terminal multiplexer.
- **ripgrep**: Repeated for clarity.

### Desktop and Window Management
Tools for locking screens and managing wallpapers in Wayland compositors.

```bash
sudo pacman -S swaylock hyprlock hyprpaper
```
- **hyprlock, hyprpaper**: Screen locker and wallpaper utility for Hyprland.

## Step 3: Post-Installation

1. **Configure Packages**:
   - Neovim: `~/init.lua
   - Tmux: `~/.tmux.conf`
   - TODO

2. **Clean Up**: Remove any temporary files or cached packages:
   ```bash
   sudo pacman -Sc
   yay -Sc
   ```

## Notes
- Run `sudo pacman -Syyu` periodically to keep your system updated.

