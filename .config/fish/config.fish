if status is-interactive
    # Commands to run in interactive sessions can go here

    if not set -q TMUX
    	exec tmux
    end

    #vim mode
    fish_vi_key_bindings
end

set XDG_CONFIG_HOME "$HOME/.config/"
set XDG_CACHE_HOME "$HOME/.cache/"

source /opt/asdf-vm/asdf.fish
zoxide init fish | source
starship init fish | source

# Created by `pipx` on 2022-09-14 09:52:50
set PATH $PATH /home/alf/.local/bin

# for language tools installed by mason
set PATH $PATH /home/alf/.local/share/nvim/mason/bin
set PATH $PATH /home/alf/Housekeeping/dotfiles/.config/scripts/

