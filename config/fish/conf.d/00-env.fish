


if test (uname) = "Linux"
	fish_add_path ~/.local/bin
end

if command -v nvim > /dev/null
	set -x MANPAGER 'nvim +Man!'
end
set -x POETRY_VIRTUALENVS_IN_PROJECT true

