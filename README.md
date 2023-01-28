# My own arch linux install guide

This is my personal guide and I will installing it with hyprland and Wayland.
If you feel lost you may visit the [`official wiki`](https://wiki.archlinux.org/title/installation_guide)!

## First-Steps
* Read the official [wiki](https://wiki.archlinux.org/title/installation_guide)
* Get the official iso image from [here](https://archlinux.org/download/)
* Verify the signature
* Prepare the installation media using [rufus](https://rufus.ie/es/), [balena](https://www.balena.io/etcher) or similar
* Boot the USB changing boot in bios.

## Keyboard-Layout
The default console keymap is US. Available layouts can be listed with:
```
# ls /usr/share/kbd/keymaps/**/*.map.gz
```
This is changeable using two methods: \
\
Temporary:
```
# loadkeys es
```
Permanently:
```
# localectl set-keymap --no-convert es
```

## Verify the boot mode
To verify the boot mode, list the efivars directory:
```
# ls /sys/firmware/efi/efivars
```
If the command shows the directory without error, then the system is booted in UEFI mode. If the directory does not exist, the system may be booted in BIOS (or CSM) mode.

## Connect to the Internet
Use to see all network interfaces
```
# ip link
```
Normally, enp0sX is the wired interface and wlanX or wlp3sX is the wireless interface.
Wired connections should be enable just by plugging in the RJ45 cable.
For wireless connections, iwctl command should be used.
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
# timedatactl set-timezone "Asia/Kolkata"
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
We need 2 partitions:
* One partition for the root directory /
* For booting in UEFI mode: an EFI system partition. \
Swap partition is optional, but it's advisable to create it aswell
Other partitions like /opt/ or /home/ can be create separately.

| Mount point | Partition                 |  Partition Type       | Suggested size          | 
|-------------|---------------------------|-----------------------|-------------------------| 
| /mnt/boot   | /dev/efi_system_partition | EFI system partition  | At least 300 MiB        | 
| [SWAP]      | /dev/swap_partition       | Linux swap            | More than 512 MiB       | 
| /mnt        | /dev/root_partition       | Linux x86-64 root (/) | Remainder of the device | 

Let's use sda as our disk.
* First we have to clean the main drive
```
# gdisk /dev/sda
```
