

-- follow the active file's working dir
vim.api.nvim_exec([[
    augroup chdir
        autocmd!
        autocmd BufEnter * silent! lcd %:p:h
    augroup END
    augroup openNeotree
        autocmd!
        autocmd BufEnter * ++once if isdirectory(expand("%")) | enew | Neotree 
    augroup END
    augroup dontCloseFoldsByDefault
        autocmd!
        autocmd BufRead * set nofoldenable
    augroup END
]],
	false
)

