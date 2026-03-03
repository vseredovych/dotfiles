# Arch Linux System Setup Guide

Full system recreation guide for an **Acer Nitro ANV15-51** running Arch Linux with Hyprland.
Hardware: Intel Raptor Lake-P (UHD) + NVIDIA RTX 4050 Mobile, NVMe SSD.

---

## 1. Base Installation

Boot from the Arch ISO and follow the [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide).
Critical steps specific to this system are noted below.

### 1.1 Disk Layout (BTRFS + EFI)

This system uses a single NVMe drive with BTRFS subvolumes and a VFAT EFI partition.

**Partition the disk:**
```bash
fdisk /dev/nvme0n1
# Partition 1: EFI  — 512 MB,  type EFI System
# Partition 2: root — remainder, type Linux filesystem
```

**Format:**
```bash
mkfs.vfat -F32 /dev/nvme0n1p1
mkfs.btrfs /dev/nvme0n1p2
```

**Create BTRFS subvolumes:**
```bash
mount /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@pkg
btrfs subvolume create /mnt/@snapshots
umount /mnt
```

**Mount with subvolumes:**
```bash
mount -o subvol=@,ssd,discard=async,compress=zstd /dev/nvme0n1p2 /mnt
mkdir -p /mnt/{home,var/cache/pacman/pkg,.snapshots,boot/efi}
mount -o subvol=@home,ssd,discard=async       /dev/nvme0n1p2 /mnt/home
mount -o subvol=@pkg,ssd,discard=async        /dev/nvme0n1p2 /mnt/var/cache/pacman/pkg
mount -o subvol=@snapshots,ssd,discard=async  /dev/nvme0n1p2 /mnt/.snapshots
mount /dev/nvme0n1p1 /mnt/boot/efi
```

### 1.2 Install Base System

```bash
pacstrap -K /mnt base linux linux-firmware btrfs-progs intel-ucode sudo vim git
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

### 1.3 Locale and Timezone

```bash
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

# Uncomment en_US.UTF-8 in /etc/locale.gen, then:
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### 1.4 Hostname and Users

```bash
echo "arch" > /etc/hostname

# Root password
passwd

# Create user
useradd -m -G wheel -s /usr/bin/zsh vs
passwd vs

# Allow wheel group to use sudo
EDITOR=vim visudo   # uncomment: %wheel ALL=(ALL:ALL) ALL
```

---

## 2. Bootloader (GRUB)

```bash
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

> **Note:** After installing the NVIDIA driver or updating the kernel, re-run `grub-mkconfig`.

---

## 3. Networking

```bash
pacman -S networkmanager iwd
systemctl enable NetworkManager
systemctl enable iwd
```

After reboot, connect with:
```bash
nmcli device wifi connect "SSID" password "password"
```

---

## 4. GPU Drivers (Intel + NVIDIA hybrid)

This system has an Intel iGPU (primary) and an NVIDIA RTX 4050 Mobile (dGPU).

```bash
pacman -S nvidia-open nvidia-utils nvidia-settings
```

**Enable NVIDIA power management services** (required for suspend/hibernate to work):
```bash
systemctl enable nvidia-hibernate nvidia-suspend nvidia-resume nvidia-persistenced
```

**Enable early KMS** for smooth boot — add `nvidia_drm` to initramfs modules:
```bash
# In /etc/mkinitcpio.conf, add to MODULES=():
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
mkinitcpio -P
grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 5. Audio (PipeWire)

```bash
pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils pavucontrol
```

PipeWire user services start automatically on login. Verify:
```bash
systemctl --user status pipewire pipewire-pulse wireplumber
```

---

## 6. Bluetooth

```bash
pacman -S bluez bluez-utils
systemctl enable bluetooth
```

---

## 7. Hyprland Desktop Stack

```bash
pacman -S hyprland hyprlock hyprpaper waybar rofi wl-clipboard \
          xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland \
          ghostty dolphin wlogout
```

**Enable Hyprland to start on login** (no display manager — launch from zsh):
```bash
# Add to ~/.zprofile:
if uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi
```

Or simply launch with `Hyprland` from a TTY login if not using a session manager.

---

## 8. Fonts

Required for waybar icons, oh-my-posh prompt, and general UI:

```bash
pacman -S ttf-jetbrains-mono ttf-jetbrains-mono-nerd otf-font-awesome
```

---

## 9. Package Managers

### Yay (AUR Helper)

```bash
sudo pacman -S base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

---

## 10. Install Packages by Category

### Development Tools

```bash
sudo pacman -S neovim luarocks python-pip pyenv uv libxml2 curl zlib nss clang
```

### System Utilities

```bash
sudo pacman -S htop btop nvtop fzf zoxide reflector inotify-tools openssh acpi
```

### Networking and VPN

```bash
sudo pacman -S nmap wget gnu-netcat openconnect networkmanager-openconnect nm-connection-editor ca-certificates
yay -S openconnect-sso
```

### Containerization

```bash
sudo pacman -S docker docker-compose docker-buildx
sudo systemctl enable docker
sudo usermod -aG docker vs
```

### Terminal and Shell

```bash
sudo pacman -S zsh tmux
chsh -s /usr/bin/zsh       # set zsh as default shell for current user
```

### Productivity

```bash
sudo pacman -S libreoffice-still obsidian flatpak
yay -S teams-for-linux mongodb-compass-bin zen-browser-bin
```

### Miscellaneous

```bash
sudo pacman -S timeshift btrfs-progs     # backup tool (see §12)
sudo pacman -S viu feh                   # image viewers
sudo pacman -S ripgrep                   # fast search (also needed by neovim)
```

### Web Engine Dependencies

```bash
sudo pacman -S webkit2gtk webkit2gtk-4.1
```

---

## 11. Deploy Dotfiles

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
bash scripts/install-dependencies.sh   # install dotfile tool dependencies
./deploy.sh                            # copy configs into ~/
```

---

## 12. Backup and Restore (Timeshift + BTRFS)

This system uses **Timeshift** to snapshot the BTRFS `@` subvolume. Snapshots are stored in `/.snapshots` (the `@snapshots` subvolume).

### Taking a Snapshot

```bash
sudo timeshift --create --comments "before update"
```

Or configure automatic snapshots in the Timeshift GUI.

### Listing Snapshots

```bash
sudo timeshift --list
```

### Restoring from a Snapshot (Live System)

If the system still boots:
```bash
sudo timeshift --restore
# Select the snapshot from the list when prompted.
# Timeshift will restore @, regenerate initramfs, and update GRUB.
```

### Restoring from the Arch ISO (System Won't Boot)

Boot the Arch ISO, then:

```bash
# Mount the BTRFS partition
mount /dev/nvme0n1p2 /mnt

# List available snapshots
ls /mnt/@snapshots/

# Restore: delete the broken @ subvolume and replace with snapshot
btrfs subvolume delete /mnt/@
btrfs subvolume snapshot /mnt/@snapshots/<snapshot-name>/@ /mnt/@

# Mount everything and chroot to regenerate bootloader
mount -o subvol=@,ssd,discard=async /dev/nvme0n1p2 /mnt
mount -o subvol=@home,ssd,discard=async /dev/nvme0n1p2 /mnt/home
mount /dev/nvme0n1p1 /mnt/boot/efi
arch-chroot /mnt

grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
exit && reboot
```

### GRUB Snapshot Boot (Non-Destructive Recovery)

GRUB can boot directly into a BTRFS snapshot without restoring it:

```bash
# In GRUB menu, edit the boot entry and append to linux line:
rootflags=subvol=@snapshots/<snapshot-name>/@
```

This lets you verify the snapshot works before committing to a restore.

---

## 13. Post-Installation Checklist

- [ ] Reboot and verify Hyprland starts
- [ ] Audio working: `wpctl status`
- [ ] NVIDIA active: `nvidia-smi`
- [ ] Docker: `docker run hello-world`
- [ ] VPN: test openconnect-sso
- [ ] Dotfiles deployed: `./deploy.sh`
- [ ] Timeshift configured with BTRFS and automatic schedule
- [ ] `sudo pacman -Sc && yay -Sc` to clear package cache
