



# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims


if test (uname) = "Linux"
	fish_add_path ~/.local/bin
	fish_add_path ~/.cargo/bin
	fish_add_path ~/go/bin
end

if command -v nvim > /dev/null
	set -x MANPAGER 'nvim +Man!'
end
set -x POETRY_VIRTUALENVS_IN_PROJECT true
set -x OBSIDIAN_HOME ~/Documents/Centre/
