
alias nvimdiff="nvim -d"
alias lg="lazygit"
alias c="llm --system 'Answer directly. Do not elaborate unless instructed. If you are asked to provide code or a command, provide only that and nothing more'"

# man flag search
function mf
    if test (count $argv) -ne 2
        echo "Usage: mansearch <program> <flag>"
        return 1
    end

    set program $argv[1]
    set flag $argv[2]

    # Open the manpage with Neovim and search for the flag
    nvim -c "Man $program | only" +"/$flag\$" +"norm nzz"
end

# Abbreviations
abbr -a nix-shell 'nix-shell --command fish'
abbr -a cd 'z'
abbr -a cd 'z'

