#
# ~/.bash_aliases
#


alias ls='lsd --group-directories-first'
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -l -a"

alias clear="tput reset"

alias bat="bat -P"

alias kb0="sudo chown $USER:$USER /sys/class/leds/asus::kbd_backlight/brightness && echo \"0\" > /sys/class/leds/asus::kbd_backlight/brightness"
alias kb1="sudo chown $USER:$USER /sys/class/leds/asus::kbd_backlight/brightness && echo \"1\" > /sys/class/leds/asus::kbd_backlight/brightness"
alias kb2="sudo chown $USER:$USER /sys/class/leds/asus::kbd_backlight/brightness && echo \"2\" > /sys/class/leds/asus::kbd_backlight/brightness"
alias kb3="sudo chown $USER:$USER /sys/class/leds/asus::kbd_backlight/brightness && echo \"3\" > /sys/class/leds/asus::kbd_backlight/brightness"

alias kb="change_kb"

alias grep='grep --color=auto'

alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"

alias update="yay -Syu --noconfirm"

alias mirrors="sudo reflector --verbose --latest 5 --country 'Spain' --age 24 --sort rate --save /etc/pacman.d/mirrorlist"

alias ull_connect="sudo openconnect --protocol=gp --quiet --background --user=alu0101470948 vpn.ull.es"

#alias backg="& disown > /dev/null 2>&1"
