# By default, just stow the package
all: stow

stow:
	stow --adopt --target=$(shell realpath ~/.config) config
	# git restore .
	tmux source ~/.config/tmux/tmux.conf

unstow:
	stow --delete --target=$(shell realpath ~/.config) config

# Phony targets do not represent files
.PHONY: all stow unstow

