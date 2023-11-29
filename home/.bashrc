#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bash_vars ]; then
    source ~/.bash_vars
fi

if [ -f ~/.bash_logout ]; then
    source ~/.bash_logout
fi

eval "$(starship init bash)"
eval "$(fnm env --use-on-cd --shell bash)"

echo -e "\n"
pfetch

# Default prompt
#PS1='[\u@\h \W]\$ '