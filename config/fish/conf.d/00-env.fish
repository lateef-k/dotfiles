


if test (uname) = "Linux"
	fish_add_path ~/.local/bin
	fish_add_path ~/.cargo/bin
	fish_add_path ~/go/bin
end

if command -v nvim > /dev/null
	set -x MANPAGER 'nvim +Man!'
end
set -x OBSIDIAN_HOME ~/Documents/Centre/
