


# Get specific versions of currently installed packages
alias nvimdiff="nvim -d"
alias ,g="lazygit"

alias c="llm --model gpt-4.1-mini --system 'Answer directly. Do not elaborate unless instructed. If you are asked to provide code or a command, provide only that and nothing more'"
alias cl="llm --model gpt-4.1-mini --system 'Answer directly. Do not elaborate unless instructed. If you are asked to provide code or a command, provide only that and nothing more' --continue"
alias ,hmi="nix-store --query --references ~/.nix-profile/ | head -n 1 | xargs nix-store --query --references"
alias ,ni="nix-store --query --references /run/current-system/sw | xargs nix-store --query --references"
alias ,pidparent="ps -o ppid= -p"
alias ,pt="pstree -p"
alias ,tmuxthispid="tmux display -p \"#{pane_pid}\""
alias dci="docker image list"
alias ,d="cd ~/Admin/dotfiles/ && nvim --cmd 'autocmd User VeryLazy FzfLua files'"
# alias ,,=fzf --bind ctrl-u:preview-page-up,ctrl-d:preview-page-down --preview 'bat --color=always {}'

# alias ,nn="fd --type directory . $OBSIDIAN_HOME | fzf"
#
# function ,nn
# fd --type directory . $OBSIDIAN_HOME | fzf \
#     --prompt="Select dir> " \
#     --header="⯈ choose a directory, ENTER to open in nvim" \
#     --preview="ls -la {}" \
#     --bind "enter:execute(bash -c '\
#           read -e -p \"Filename: \" f; \
#           nvim \"{}\"/\"$f\"\
#         ')"
# end
# funcsave ,nn
#

# Abbreviations
abbr -a nix-shell 'nix-shell --command fish'
abbr -a cd 'z'






# certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n "bbyn-ca2" -i /usr/local/share/ca-certificates/bbyn-ca2.crt
# certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n "bbyn-ca3" -i /usr/local/share/ca-certificates/bbyn-ca3.crt
# certutil -d sql:$HOME/.pki/nssdb/ -L # list them


