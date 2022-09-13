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
