# Disable greeting
set fish_greeting

# theme
fish_config theme choose "Seaweed"

alias nvimdiff="nvim -d"
alias lg="lazygit"

# Abbreviations
abbr -a nix-shell 'nix-shell --command fish'
abbr -a cd 'z'

# Environment
set -x MANPAGER 'nvim +Man!'

fish_vi_key_bindings
