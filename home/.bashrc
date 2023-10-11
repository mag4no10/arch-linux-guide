#
# ~/.bashrc
#

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

export LC_ALL=en_US.UTF-8
export HYPRSHOT_DIR="~/Pictures"
export EDITOR="lunarvim"
export TERMINAL='kitty'
export BROWSER='google-chrome-stable'
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/lib/rustup/bin:/var/lib/snapd/snap/bin:/home/atenea/Scripts:/home/atenea/.local/bin"

eval "$(starship init bash)"

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_pfetch
fi
echo -e "\n"
pfetch
