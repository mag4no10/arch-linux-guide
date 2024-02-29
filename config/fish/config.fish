#
# $HOME/.config/config.fish
#

source $HOME/.config/fish/aliases.fish
source $HOME/.config/fish/vars.fish

if status is-interactive
    set fish_greeting
    starship init fish | source
    fnm env --use-on-cd | source
    #pfetch
    nerdfetch
end
