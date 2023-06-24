# Install Arch Linux in VirtualBox

Quick install guide for Arch -- if you're looking for an automated
installer, consider
[Arch Anywhere](https://github.com/deadhead420/arch-linux-anywhere).

## Download

Download the latest version from:
https://www.archlinux.org/download/

Verify checksums.

## Prepare VM

Create a new VM, choose type Linux and version Arch Linux (64-bit) and activate efi.
Allocate a reasonable amount of RAM and create a new hard disk.

Make sure the VM has two network adapters enabled: Adapter 1 attached
to NAT and Adapter 2 attached to Host-only adapter `vboxnet0` if you
have multiple VMs inside a host-only network.

Attach the ISO image to your VM and boot into Arch's live system.

## Pre-flight checks

Check network: `ping archlinux.org`

## Installation

Partition the disk:
  1.  `fdisk /dev/sda`
  2. `n` -- new partition
  3. (enter) (`p` -- primary disk)
  4. (enter) (`1` -- partition number)
  5. (enter) set first sector
  6. (enter) set last sector (use whole disk)
  7. `w` -- write partition table and quit

Format partition:  
`mkfs.ext4 /dev/sda1`
 
Mount the filesystem:  
`mount /dev/sda1 /mnt`

Install the base packages:  
`pacstrap /mnt base`

Generate `/etc/fstab`:  
`genfstab -U /mnt >>/mnt/etc/fstab`

Change root to the newly created system:  
`arch-chroot /mnt`

Set the timezone, e.g.:  
`ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime`

Generate `/etc/adjtime`:  
`hwclock --systohc`

Enable locale:
  1. Uncomment your preferred locale (e.g. `en_US.UTF-8 UTF-8`) in
     `/etc/locale.gen` using `vi`.
  2. Run `locale-gen`.
  3. Put the corresponding `LANG` variable (e.g. `LANG=en_US.UTF-8`)
     in `/etc/locale.conf`:  
     `echo 'LANG=en_US.UTF-8' >/etc/locale.conf`

Set hostname (e.g. `arch`):  
`echo arch >/etc/hostname`

Enable DHCP client daemon:  
`systemctl enable dhcpcd`

Set root password:  
`passwd`  
`(your password)`  
`(your password)`

Install GRUB:
  1. `pacman -S grub`
  2. `grub-install --target=i386-pc /dev/sda`
  3. `grub-mkconfig -o /boot/grub/grub.cfg`

Reboot:
  1. `exit`
  2. `umount -R /mnt`
  3. `reboot`

Now boot from the first hard disk.

## Post-installation steps

Login as `root` using your password.

Add non-root user with sudo permissions and Zsh as the default shell:
  1. Install sudo and Zsh:  
     `pacman -S sudo zsh`
  2. Add user (e.g. John):  
     `useradd -m -g users -s /usr/bin/zsh john`
  3. Set password:  
     `passwd john`  
     `(your password)`  
     `(your password)`
  4. Edit `/etc/sudoers` using `EDITOR=vi visudo` and add permissions,
     e.g.:  
     `john ALL=(ALL) ALL`

Setup swap:
  1. Install systemd-swap:  
     `pacman -S systemd-swap`
  2. Enable the swap daemon:  
     `systemctl enable systemd-swap`

Install X11:
  1. Install required packages:  
     `pacman -S xorg-server xorg-server-utils xorg-xinit xorg-apps xterm`
  2. Install video driver:  
     `pacman -S xf86-video-vesa`
  3. Install default terminal:  
     `pacman -S xterm`
  4. Install some popular fonts:  
     `pacman -S ttf-dejavu ttf-droid ttf-inconsolata`

Update the system:  
`pacman -Syu`

## Optional steps

  - Install your window manager of choice.
  - Activate bi-directional clipboard in the VM settings and install the Guest Additions.
  - Switch to `linux-lts` kernel.
