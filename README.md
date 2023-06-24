# My own arch linux install guide

This is my personal guide and I will installing it with hyprland and Wayland.
If you feel lost you may visit the [`official wiki`](https://wiki.archlinux.org/title/installation_guide)!

## First-Steps
* Read the official [wiki](https://wiki.archlinux.org/title/installation_guide)
* Get the official iso image from [here](https://archlinux.org/download/)
* Verify the signature
* Prepare the installation media using [rufus](https://rufus.ie/es/), [balena](https://www.balena.io/etcher) or similar
* Boot the USB changing the boot order in bios.

## Keyboard-Layout
The default console keymap is US. Available layouts can be listed with:
```
# ls /usr/share/kbd/keymaps/**/*.map.gz
```
This is changeable using two methods: (better temporary for the moment) \
\
Temporary:
```
# loadkeys es
```
Persistent:
```
# localectl set-keymap --no-convert es
```

## Verify the boot mode
To verify the boot mode, list the efivars directory:
```
# ls /sys/firmware/efi/efivars
```
If the command shows some directories without any errors, then the system is booted in UEFI mode. Otherwise, the system may be booted in BIOS mode.

## Connect to the Internet
First, try pinging in order to know if we are already connected to the Internet
```
ping archlinux.org
```
If we are connected, you may skip this step [*](https://github.com/mag4no10/arch-linux-guide#update-the-system-clock)

Numerate all network interfaces
```
# ip link
```
Normally, enp0sX is the wired interface and wlanX or wlp3sX are the wireless interfaces.
Wired connections should be enabled just by plugging in the RJ45 cable.
For wireless connections, iwctl command should be used. \
(I will be using wlan0 for convenience, use your own interface name)

First start the iwc daemon:
```
# systemctl enable --now iwd
```
Now scan the close range connections
```
# iwctl station wlan0 scan
```
Get a list of the scanned networks
```
# iwctl station wlan0 get-networks
```
Then connect to the desired one
```
# iwctl -P "PASSPHRASE" station wlan0 connect "NETWORKNAME"
```
Finally check if the connection is established by sending one ICMP packet
```
# ping -c1 archlinux.org
``` 
If you get Unknown host or Destination host unreachable response, you are not online yet. Check last steps

## Update the system clock
This command shows the system clock.
```
timedatectl status
```
If it is desirable to change the timezone, use this commands:
```
# timedatactl list-timezones | grep "Europe/"  | less
# timedatactl list-timezones | grep "Asia/"    | less
# timedatactl list-timezones | grep "America/" | less
```
Then apply the changes
```
# timedatactl set-timezone "Europe/Dublin"
```
\
To change Time and Date
```
# timedatectl set-time '2023-01-28 19:42:50'
```

## Partition the disks
When recognized by the live system, disks are assigned to a block device such as /dev/sda, /dev/nvme0n1 or /dev/mmcblk0. To identify these devices, use lsblk or fdisk.
```
# lsblk
```
Results ending in rom, loop or airoot may be ignored.
We need at least 2 partitions:
* One partition for the root directory /
* For booting in UEFI mode: an EFI system partition. \

Swap partition is optional, but it's advisable to create it aswell
Other partitions like /var /opt or /home can be create separately. \
If you are installing arch in a vm, I simply recommend installing a root(/) and a home(/home) partition.

| Mount point | Partition                 |  Partition Type       | Suggested size          | 
|-------------|---------------------------|-----------------------|-------------------------| 
| /mnt/boot   | /dev/efi_system_partition | EFI system partition  | At least 300 MiB        | 
| [SWAP]      | /dev/swap_partition       | Linux swap            | More than 512 MiB       | 
| /mnt        | /dev/root_partition       | Linux x86-64 root (/) | Remainder of the device | 

Let's use sda as our disk.
*DISCLAIMER* IF YOU HAVE ALREADY AN EXISTING OPERATING SYSTEM AND YOU ARE PLANNING TO DUAL-BOOT, DO NOT CLEAN THE MAIN DRIVE. \
* First we have to clean the main drive
```
# gdisk /dev/sda
```
* Press <kbd>x</kbd> to enter **expert mode**. Then press <kbd>z</kbd> to *zap* our drive. Then hit <kbd>y</kbd> when prompted about wiping out GPT and blanking out MBR. Note that this will ***zap*** your entire drive so your data will be gone - reduced to atoms after doing this. THIS. CANNOT. BE. UNDONE.

* Now we are going to start partitioning our filesystem
```
# cgdisk /dev/sda
```
* Press <kbd>Return</kbd> when warned about damaged GPT.
Now the screen shows the list of partitions. Naturally, it must show free space since we have cleaned our disk, otherwise, feel free to delete all partitions.
**To select all avaiable space, just simply leave sector space blank**

+ Create the `boot` partition
	- If you already have a efi partition that is being used by windows or other os, do not create another one. Just mount the existing one to /mnt/efi
	- Hit New from the options at the bottom.
	- Just hit enter to select the default option for the first sector.
	- Now the partion size - Arch wiki recommends 200-300 MB for the boot + size. Let’s make 1GiB in case we need to add more OS to our machine. I’m gonna assign mine with 1024MiB. Hit enter.
	- Set GUID to `EF00`. Hit enter.
	- Set name to `boot`. Hit enter.
	- Now you should see the new partition in the partitions list with a partition type of EFI System and a partition name of boot. You will also notice there is 1007KB above the created partition. That is the MBR. Don’t worry about that and just leave it there.

+ Create the `swap` partition

	- Hit New again from the options at the bottom of partition list.
	- Just hit enter to select the default option for the first sector.
	- For the swap partition size, I always assign mine with 1GiB. Hit enter.
	- Set GUID to `8200`. Hit enter.
	- Set name to `swap`. Hit enter.

+ Create the `root` partition

	- Hit New again.
	- Hit enter to select the default option for the first sector.
	- Hit enter again to input your root size.
	- Also hit enter for the GUID to select default(`8300`).
	- Then set name of the partition to `root`.

+ Create the `home` partition

	- Hit New again.
	- Hit enter to select the default option for the first sector.
	- Hit enter again to use the remainder of the disk.
	- Also hit enter for the GUID to select default.
	- Then set name of the partition to `home`.

+ Lastly, hit `Write` at the bottom of the patitions list to *write the changes* to the disk. Type `yes` to *confirm* the write command. Now we are done partitioning the disk. Hit `Quit` *to exit cgdisk*. Go to the [next section](#formatting-partitions).

## Format the partitions
Once we got our partitions created, we must give them an appropiate type. For swap it is swap type, for efi it is fat32 but in the other hand, root and home are kinda debatable. People usually use EXT4, but there are other benefits about using btrfs or xfs. We will be using the old EXT4, but it is up to you. \
(In my case, sda1 is efi, sda2 is swap, sda3 is root and sda4 is home, but is may not be in yours. Check it out!)
```
# mkfs.ext4 /dev/sda3
# mkfs.ext4 /dev/sda4
# mkswap /dev/sda2
# mkfs.fat -F32 /dev/sda1
```

## Mount the file systems
Mount the root volume to /mnt
```
# mount /dev/sda3 /mnt
```
Create a boot mount point and assign it to efi partition
```
mount --mkdir /dev/sda1 /mnt/efi
```
Now create a home mount point and assign it to home partition
```
mount --mkdir /dev/sda4 /mnt/home
```
Finally enable swap volume with swapon
```
swapon /dev/sda2
```

## Installation
We are halfway done. Let's install the base linux packages with pacstrap
```
# pacstrap /mnt base base-devel linux linux-firmware vim
```
This will install ONLY ESSENTIAL PACKAGES. Once all is finished, you must install other apps in order to make a functional system. Here are a few examples:
* userspace utilities for the management of file systems that will be used on the system:
  - unrar
  - unzip
  - android-udev
  - ntfs-3g 
* utilities for accessing RAID or LVM partitions:
  - lvm2
* specific firmware for other devices not included in `linux-firmware`:
* software necessary for networking:
  - dhcpcd
  - iwd
  - inetutils
  - iputils
* text editor:
  - nano
  - vi
  - vim
  - neovim
* packages for accessing documentation in man and info pages:
  - man-db
  - man-pages
Dont forget to install this later !!!

## Fstab
This is a file that stores descripting information about all filesystems in our linux system. 
```
# genfstab -U /mnt >> /mnt/etc/fstab
```
Check the resulting /mnt/etc/fstab file, and edit it in case of errors.

## Chroot
Change root into the new system:
```
# arch-chroot /mnt
```
## Timezone
Set the time zone, list of available timezones are in `/usr/share/zoneinfo/`. Select yours and link it to your localtime:
```
# ln -sf /usr/share/zoneinfo/Europe/Dublin /etc/localtime
```
Run hwclock to generate /etc/adjtime
(hwclock is used to adjust hardware clock)
```
# hwclock --systohc
```

## Localization
Locale is the language that your system is going to use. This include characters, numbers and other specials symbols. \
Possible options are located in `/etc/locale.gen`. \
If you used loadkeys earlier, you may make the layout persistent \
Open this file, scroll and uncomment your preferred locale. I'm using en_US.UTF-8 UTF-8
```
# vim /etc/vconsole.conf
```
Generate the locales by running:
```
# locale-gen
```
Next, create a new locale configuration file and save the locale as shown.
```
# echo "LANG=EN_US.UTF-8" > /etc/locale.conf
```

## Network Configuration
You can use this command to create a hostname
```
# hostnamectl set-hostname myhostname
```
Alternatively, you can create and edit the hostname file
```
# echo "IncredibleHostname" > /etc/hostname
```
Now open `/etc/hosts` to add matching entries to `hosts`
```
127.0.0.1    localhost  
::1          localhost  
127.0.1.1    MYHOSTNAME.localdomain	  MYHOSTNAME
```
If the system has a permanent IP address, it should be used instead of `127.0.1.1`.
Download this packages that will help ur later. 
```
# pacman -S netctl wpa_supplicant ifplugd
```

## Initramfs
Creating a new initramfs is usually not required, because mkinitcpio was run on installation of the kernel package with pacstrap.
For LVM, system encryption or RAID, modify mkinitcpio.conf(5) and recreate the initramfs image.
```
# mkinitcpio -P
```

## Root Password
Set the root password
```
# passwd
```

## Adding Repositories - `multilib` and `AUR`
Enable multilib and AUR repositories in `/etc/pacman.conf`. Open it with your editor of choice
### Adding multilib repository
Uncomment `multilib` (remove # from the beginning of the lines)
### Add the following lines at the end of your `/etc/pacman.conf` to enable the AUR repo
```
[archlinuxfr]
Server = http://repo.archlinux.fr/$arch
```
### `pacman` easter eggs
You can enable the "easter-eggs" in `pacman`, the package manager of archlinux.\
Open `/etc/pacman.conf`, then find `# Misc options`. \
To add colors to `pacman`, uncomment `Color`. Then add `Pac-Man` to `pacman` by adding `ILoveCandy` under the `Color` string:
```
Color
ILoveCandy
```
### Update repositories and packages
To check if you successfully added the repositories and enable the easter-eggs, execute:
```
# pacman -Syu
```
If updating returns an error, open the `pacman.conf` again and check for human errors. Yes, you f'ed up big time.

## Add a user account
Add a new user account. In this guide, I'll just use `MYUSERNAME` as the username of the new user aside from `root` account.
```
# useradd -m -g users -G wheel,storage,power,video,audio,rfkill,input -s /bin/bash MYUSERNAME
```
This will create a new user and its `home` folder. \
Set the password of user `MYUSERNAME`:  
```
# passwd MYUSERNAME
```
## Add the new user to sudoers:
If you want a root privilege in the future by using the `sudo` command, you should grant one yourself:
```
# EDITOR=vim visudo
```
Uncomment the line (Remove #):
```
# %wheel ALL=(ALL) ALL
```

## Install the boot loader
You can install `systemd-boot` or `grub`, here's the installation of both:
###systemd-boot
```
# bootctl --path=/boot install
```
Create a boot entry `/boot/loader/entries/arch.conf`, then add these lines:
```
title Arch Linux  
linux /vmlinuz-linux  
initrd  /initramfs-linux.img  
options root=/dev/sda3 rw
```
If your `/` is not in `/dev/sda3`, make sure to change it. \

Now update boot loader configuration
```
# vim /boot/loader/loader.conf
```
Delete all of its content, then replaced it by:
```
default arch.conf
timeout 0
console-mode max
editor no
```
###grub
Install base grub packages
```
# pacman -S grub efibootmgr
```
If you dual-boot with other operating systems, you may consider installing os-prober
```
# pacman -S os-prober
```
Then install grub on the EFI directory as shown
```
# grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
```
Now run this command to show boot entries but Arch
```
# os-prober
```
If you have other os and it is not in the output, follow this steps:
```
# exit
# cgdisk /dev/sda
(now change the label of efi partition to boot and write changes)
# vim /etc/default/grub
(uncomment "GRUB_DISABLE_OS_PROBER=false" and exit)
```
Finally install the grub configuration file
```
# grub-mkconfig -o /boot/grub/grub.cfg
```

## Enable internet connection for the next boot

To enable the network daemons on your next reboot, you need to enable `dhcpcd.service` for wired connection and `iwd.service` for a wireless one.
```
# systemctl enable dhcpcd iwd
```

## Exit chroot and reboot:  
Exit the chroot environment by typing `exit` or pressing <kbd>Ctrl + d</kbd>. You can also unmount all mounted partition after this. 
Finally, `reboot`. \

## Next steps
Now we gotta install display server or protocol, a window manager and compositor (X11), besides all the packages that will convert our system in a rice linux, just like this [unixp*rn](https://www.reddit.com/r/unixporn/)
