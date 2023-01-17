

-- follow the active file's working dir
vim.api.nvim_exec([[
    augroup chdir
        autocmd!
        autocmd BufEnter * silent! lcd %:p:h
    augroup END
    augroup dontCloseFoldsByDefault
        autocmd!
        autocmd BufReadPost,FileReadPost * setlocal foldlevel=3
    augroup END
]],
	false
)


