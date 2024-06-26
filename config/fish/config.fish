if status is-interactive
    # Commands to run in interactive sessions can go here

    if not set -q TMUX
        exec tmux
    end

    #vim mode
    # https://stackoverflow.com/questions/48956984/how-to-remap-escape-insert-mode-to-jk-in-fish-shell
end

function fish_user_key_bindings
    fish_vi_key_bindings
    # bind -m default \$ end-of-line
    # bind -m default ^ beginning-of-line
    bind -M insert -m default jk backward-char force-repaint
    bind -M insert -m default kj backward-char force-repaint
end

set EDITOR nvim
set XDG_CONFIG_HOME "$HOME/.config/"
set XDG_CACHE_HOME "$HOME/.cache/"

source /opt/asdf-vm/asdf.fish
zoxide init fish | source #try zi
starship init fish | source

direnv hook fish | source
set -g direnv_fish_mode disable_arrow

# Created by `pipx` on 2022-09-14 09:52:50
set PATH $PATH /home/alf/.local/bin

# for language tools installed by mason
fish_add_path /home/alf/.local/share/nvim/mason/bin
# installed without package manager
fish_add_path ~/.cargo/bin

#for fzf.fish plugin (jethrokuan/fzf)
set -U FZF_COMPLETE 3
set -U FZF_LEGACY_KEYBINDINGS 0
#options to pass to fzf, alt-enter to toggle multiple files
set -U FZF_DEFAULT_OPTS "--bind tab:down,btab:up,alt-enter:toggle-out"
: '
Ctrl-o 	Find a file.
Ctrl-r 	Search through command history.
Alt-c 	cd into sub-directories (recursively searched).
Alt-Shift-c 	cd into sub-directories, including hidden ones.
Alt-o 	Open a file/dir using default editor ($EDITOR)
Alt-Shift-o 	Open a file/dir using xdg-open or open command
'
# function man
#     nvim -c ":Man $argv | only"
# end
