#!/bin/bash
NC='\033[0m' # No Color
CYAN='\033[0;36m'

if [ "$EUID" -ne 0 ]
  then printf "${CYAN}Please run as root \n"
  exit
fi


printf "${CYAN}Copying the theme in the right folder \n"
cp -r ./themes /boot/grub
printf "${CYAN}If there are no error the themes was copied succefully :D \n"

printf "${CYAN}Changing theme to "virtuaverser" \n"
printf "${CYAN}You can see other settings in file ./default/grub \n"

awk -i inplace '/GRUB_THEME=/ {gsub(/"[^"]+"/, "\"/boot/grub/themes/virtuaverse/theme.txt\"")} 1' /etc/default/grub
printf "${CYAN}If there are no error grub file copied succefully \n"

printf "${CYAN}Executing grub update ${NC}\n"
sudo update-grub
printf "${CYAN}Grub updated \n ${NC}"
