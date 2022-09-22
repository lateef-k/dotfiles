if status is-interactive
    # Commands to run in interactive sessions can go here

    if not set -q TMUX
    	exec tmux
    end

    #vim mode
    fish_vi_key_bindings
end
set EDITOR "nvim"

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

#for fzf.fish plugin (jethrokuan/fzf)
set -U FZF_COMPLETE 3
set -U FZF_LEGACY_KEYBINDINGS 0
#options to pass to fzf, alt-enter to toggle multiple files
set -U FZF_DEFAULT_OPTS "--bind tab:down,btab:up,alt-enter:toggle-out"
'
Ctrl-t 	Ctrl-o 	Find a file.
Ctrl-r 	Ctrl-r 	Search through command history.
Alt-c 	Alt-c 	cd into sub-directories (recursively searched).
Alt-Shift-c 	Alt-Shift-c 	cd into sub-directories, including hidden ones.
Ctrl-o 	Alt-o 	Open a file/dir using default editor ($EDITOR)
Ctrl-g 	Alt-Shift-o 	Open a file/dir using xdg-open or open command
'
