


alias nvimdiff="nvim -d"
alias ,lg="lazygit"
alias c="llm --system 'Answer directly. Do not elaborate unless instructed. If you are asked to provide code or a command, provide only that and nothing more'"
# Get specific versions of currently installed packages
alias ,hmi="nix-store --query --references ~/.nix-profile/ | head -n 1 | xargs nix-store --query --references"
alias ,ni="nix-store --query --references /run/current-system/sw | xargs nix-store --query --references"
alias ,pidparent="ps -o ppid= -p"
alias ,pt="pstree -p"
alias ,tmuxpid="tmux list-panes -a -F \"#{pane_pid}: #{session_id} #{window_id} #{pane_id}\" | grep "
alias ,tmuxthispid="tmux display -p \"#{pane_pid}\""
alias dci="docker image list"
alias ,d="cd ~/Dotfiles/ && nvim --cmd 'autocmd User VeryLazy FzfLua files'"

alias sqlite3="rlwrap sqlite3"

# Abbreviations
abbr -a nix-shell 'nix-shell --command fish'
abbr -a cd 'z'

