
# FZF keymaps
# bind ctrl-r fzf-history-widget
# bind -M insert ctrl-r fzf-history-widget
# bind ctrl-t fzf-file-widget
# bind -M insert ctrl-t fzf-file-widget
# bind alt-c fzf-cd-widget
# bind -M insert alt-c fzf-cd-widget
#
set fish_greeting

fish_vi_key_bindings

# if test $NVIM
# 	fish_default_key_bindings
# else
# 	fish_vi_key_bindings
# end

# theme
fish_config theme choose "Lava"



# Very Useful for debugging
# strace -e trace=network,file -f -s 512 [command] 2&> trace
# bat trace


# intercept DNS queries
# tcpdump -X port 53
