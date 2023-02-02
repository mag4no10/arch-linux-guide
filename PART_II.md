# My own arch linux install guide pt2
After rebooting, we will already got our functional system. So now we will be installing our packages. \

## Connect to the Internet
When we installed base packages, we also installed vim and dhcpcd, so now we can just enable dhcpcd
```
# systemctl start dhcpcd
# reboot
```
Now we have a connection established

## Installing packages
[this](https://wiki.archlinux.org/title/List_of_applications) is a list of packages that we can install in our system. Feel free to check them out and choose your preferences. \
First I will be installing yay
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

* Network connections
  - globalprotect-openconnect-git
  - networkmanager 
  - tor 
  - curl
  - wget
  - gnu-netcat
  - inetutils (ftp...)
  - openssh
  - qbittorrent
* Browsers
  - librewolf
  - google-chrome
  - w3m
* General
  - xclip
  - discord
  - neofetch
  - libreoffice-fresh
  - flameshot
  - droidcam
  - trashmanager
  - tar
  - zip
  - rar
  - gzip
  - fbxkb
  - duc
  - czkawka-cli
  - virtualbox
  - tree
  - asciidoctor
  - texlive-core
  - masterpdfeditor-free
  - basket
* Multimedia
  - vlc
  - feh
  - gimp
  - cmus
  - lollypop
  - spotify
  - audacity
  - ffmpeg
  - ffmpegyag
* Volume control
  - alsa-utils
  - pavucontrol
* Terminal emulator
  - alacritty
  - kitty
  - xterm
* Command line shell
  - Fish
* Terminal pagers
  - less
  - more
* Text editor
  - vim
  - gedit
  - nvim
  - code
* file managers
  - ranger
  - thunar
* Development
  - make
  - cmake
  - meson
  - gcc
  - r
  - python
* Fonts
  - Hack nerd font
  - Fira code
* System
  - corestats
  - htop
  - hwinfo
* Bluetooth
  - bluez-utils
  - bluez
  - blueman
* Display Server and Protocol
  - x
  - wayland
* Database
  - adminer
  - mycli
  - sqlite
* Security
  - nmap
  - tcpdump
  - john
  - hashcat
  - (add blackarch repo)
* Screenlockers
  - betterlockscreen
  - i3lock

First, we have to check for updates in our system
```
# sudo pacman -Syu
```
Now we need to install a display server/protocol, I will be installing xorg with awesomeWM
```
# pacman -S xorg
```
Then, we install gpu drivers. I'll be installing nvidia ones, but for laptops with integrated and discrete gpu, this link will be useful
```
https://www.reddit.com/r/linux_gaming/comments/f79trt/how_to_setup_a_ryzen_laptop_with_an_nvidia_gpu/
```
```
# pacman -S nvidia nvidia-utils nvidia-settings opencl-nvidia
```
Audio drivers
```
# pacman -S alsa-utils pulseaudio-alsa pulseaudio-bluetooth pulseaudio pavucontrol
```
File system tools
```
# pacman -S unrar unzip p7zip unarchiver gvfs-mtp libmtp ntfs-3g android-udev mtpfs xdg-user-dirs
```
Create home subdirectories (Downloads,Pictures...)
```
xdg-user-dirs-update
```
Install missing firmware. We check for them using the command mkinitcpio
```
# mkinitcpio -p linux
```
In my case, these are the missing ones
```
# yay -S ast-firmware wd719x-firmware aic94xx-firmware linux-firmware-qlogic upd72020x-fw
```
