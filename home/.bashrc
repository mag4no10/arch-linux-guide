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
export EDITOR="neovim"
export TERMINAL='kitty'
export BROWSER='google-chrome-stable'

eval "$(starship init bash)"

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_pfetch
fi
echo -e "\n"
pfetch