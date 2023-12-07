# My own arch linux install guide pt2
After rebooting, we will already got our functional system. So now we will be installing our packages. \

## Connect to the Internet
First we check if we have connection
```
# ping archlinux.org
```
If it outputs a name resolution related error, we may use iwd and dhcpcd to connect to Internet \
```
# iwctl station wlan0 connect "WIFI_SSID"
# iwctl station wlan0 show
```
if state is connected, we got our connection, now it's time to assign an ip using dhcp daemon
```
# sudo systemctl enable dhcpcd
# sudo dhcpcd
```
And we check for our ip
```
# ip a
```

## Installing packages
First, we have to check for updates in our system
```
# sudo pacman -Syu
```
[This](https://wiki.archlinux.org/title/List_of_applications) is a list of packages that we can install in our system. Feel free to check them out and choose your preferences. \
The first package I will be installing is yay, to be able to access the [AUR](https://aur.archlinux.org/)
```
# pacman -S git
# cd /opt
# git clone https://aur.archlinux.org/yay-git.git
# sudo "your user"
# chown -R "your user" yay-git
# cd yay-git
# makepkg -si
```
Now we can search for the rest of the desired packages

### Network connections

```
# yay -S networkmanager tor curl wget inetutils openssh qbittorrent openconnect openvpn
```
### Browsers
```
# yay -S librewolf-bin google-chrome w3m
```
### General Purpose
```
# yay -S xclip discord_arch_electron libreoffice-fresh tar zip rar gzip virtualbox tree asciidoctor 
```
### Multimedia
```
# yay -S vlc feh gimp ffmpeg ffmpegyag alsa-utils blueman bluez pulseaudio pulseaudio-module-bluetooth pavucontrol bluez-utils
```
### Terminal emulator
```
# yay -S kitty xterm fish
```
### Terminal pagers
```
# yay -S less
```
### Text editor
```
# yay -S vim nano neovim visual-studio-code-bin
```
### file managers
```
# yay -S ranger thunar
```
### Development
```
# yay -S make cmake meson gcc python
```
### Fonts
```
# yay -S ttf-hack-nerd ttf-firacode
```
### System
```
# yay -S corestats btop hwinfo
```

### Display Server and Protocol
  - x
  - wayland
We will discuss this later !

### Database
```
# yay -S sqlite mysql
```

### Security
```
# yay -S nmap tcpdump john netcat hashcat wireshark-qt
```

### Screenlockers
```
# yay -S i3lock
```

## Create home subdirectories (Downloads,Pictures...)
```
# yay -S xdg-user-dirs
# xdg-user-dirs-update
```
Install missing firmware. We check for them using the command mkinitcpio
```
# mkinitcpio -p linux
```
In my case, these are the missing ones
```
# yay -S ast-firmware wd719x-firmware aic94xx-firmware linux-firmware-qlogic upd72020x-fw
```

## Installing a compositor / window manager
In this setup, I will install Wayland protocol + Hyprland. Beware that nvidia gpus got awful performance and compatibility with wayland, but thanks to [sol](https://github.com/SolDoesTech), it aparently has some support \
I will split the process in various stages in order to make it clear

### STAGE I (prework)
```
# yay -S qt5-wayland qt5ct qt6-wayland qt6ct qt5-svg qt5-quickcontrols2 qt5-graphicaleffects gtk3 polkit-gnome pipewire wireplumber jq wl-clipboard cliphist python-requests pacman-contrib
```
### STAGE II (personal preference packages)
```
# yay -S globalprotect-openconnect-git networkmanager tor curl wget gnu-netcat inetutils openssh qbittorrent librewolf-bin google-chrome xclip discord pfetch libreoffice-fresh flameshot tar zip unzip rar unrar gzip fbxkb virtualbox tree asciidoctor texlive-core vlc feh gimp lollypop audacity ffmpeg ffmpegyag alsa-utils pavucontrol fish starship less more vim nvim gedit code ranger caja make cmake gcc meson r python ttf-hack-nerd ttf-firacode-nerd corestats btop hwinfo nmap tcpdump john hashcat   
```
### STAGE III (main packages)
```
# yay -S kitty mako waybar swww swaylock-effects wofi wlogout xdg-desktop-portal-hyprland swappy grim slurp mpv pamixer pavucontrol brightnessctl bluez bluez-utils blueman network-manager-applet gvfs thunar thunar-archive-plugin file-roller papirus-icon-theme noto-fonts-emoji lxappearance xfce4-settings nwg-look-bin sddm    
```
### STAGE IV (nvidia gpus only)
```
# yay -S linux-headers nvidia-dkms nvidia-settings libva libva-nvidia-driver-git
```
[Useful link to ppl with amd apu + nvidia gpu](https://www.reddit.com/r/linux_gaming/comments/f79trt/how_to_setup_a_ryzen_laptop_with_an_nvidia_gpu/)
Update config
```
# sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
# mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
# echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
```
### STAGE V
Non-nvidia users:
```
# yay -S hyprland
```
Nvidia users:
```
# yay -S hyprland-nvidia
# echo -e "\nsource = ~/.config/hypr/env_var_nvidia.conf" >> ~/.config/hypr/hyprland.conf
```
### STAGE VI (asus rog users only)
Add rog repository \
First add key
```
# sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
# sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
# sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
# sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
```
Add repository to /etc/pacman.conf
```
echo -e "\n[g14]\nSigLevel = Optional TrustAll\nServer = https://arch.asus-linux.org"
```
Update
```
# yay -Syu
```
Install rog packages and enabling its services
```
# yay -S asusctl supergfxctl rog-control-center
# systemctl enable --now power-profiles-daemon.service
# systemctl enable --now supergfxd
```



TODO: \
  AÑADIR EN HYTPRLAND.CONF \
    KEYMAP \
    NVIDIA | NONVNDIA ENV \
    monitor=DP-1,1920x1080@144,0x0,1 \
    https://github.com/SolDoesTech/HyprV4/blob/main/HyprV/hypr/hyprland.conf
    
    
  ufw \
  amd microcode and theme grub \
  issues with resolution, xrandr --listmonitors, xrandr --output <OUTPUT> --mode <RESOLUTION>, if problem, cvt \
  install batcat \
  aliases \
  locales \
  grub-silent \
  reflector \
  lsd \
