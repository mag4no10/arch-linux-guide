#
# $HOME/.config/aliases.fish
#


alias ls="lsd --group-directories-first"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -l -a"
alias lst="ls -l --tree"
alias lsat="ls -l -a --tree"

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

alias ull_connect="sudo openconnect --protocol=gp --quiet --background vpn.ull.es"

alias discord="google-chrome-stable --app="http://discord.com/app" --class=WebApp-Discord3840 --user-data-dir=/home/atenea/.local/share/ice/profiles/Discord3840"
