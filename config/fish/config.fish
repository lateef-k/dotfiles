# FZF keymaps
# bind ctrl-r fzf-history-widget
# bind -M insert ctrl-r fzf-history-widget
# bind ctrl-t fzf-file-widget
# bind -M insert ctrl-t fzf-file-widget
# bind alt-c fzf-cd-widget
# bind -M insert alt-c fzf-cd-widget

set fish_greeting
fish_config theme choose "Lava"

function fish_user_key_bindings
  if command -s fzf-share >/dev/null
    source (fzf-share)/key-bindings.fish
  end

  fish_vi_key_bindings
  fzf_key_bindings
end

# ------------------ Environment ------------------------
if test (uname) = "Linux"
	fish_add_path ~/.local/bin
	fish_add_path ~/.cargo/bin
	fish_add_path ~/go/bin
end
if command -v nvim > /dev/null
	set -x MANPAGER 'nvim +Man!'
end
set -x OBSIDIAN_HOME ~/Documents/Centre/
set -x EDITOR vim
# -------------------------------------------------------

# ---------------------- Alias --------------------------
# Get specific versions of currently installed packages
alias nvimdiff="nvim -d"
alias ,g="lazygit"

alias c="llm --model gpt-5-mini -o reasoning_effort minimal --system 'Answer directly. Do not elaborate unless instructed. If you are asked to provide code or a command, provide only that and nothing more'"
alias cl="llm --model gpt-5-mini -o reasoning_effort low --system 'Answer directly. Do not elaborate unless instructed. If you are asked to provide code or a command, provide only that and nothing more' --continue"
alias ,hmi="nix-store --query --references ~/.nix-profile/ | head -n 1 | xargs nix-store --query --references"
alias ,ni="nix-store --query --references /run/current-system/sw | xargs nix-store --query --references"
alias dci="docker image list"

alias ,d="cd ~/Admin/dotfiles/ && nvim --cmd 'autocmd User VeryLazy FzfLua files'"
# Abbreviations
abbr -a nix-shell 'nix-shell --command fish'

if test (command -v z)
	abbr -a cd 'z'
end
# -------------------------------------------------------
