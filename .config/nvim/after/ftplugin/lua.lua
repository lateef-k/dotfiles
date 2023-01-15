
local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = true }

map({"n","v"},"<localleader>rl","<Plug>(Luadev-RunLine)",opts)
map({"n","v"},"<localleader>r","<Plug>(Luadev-Run)",opts)
map({"n","v"},"<localleader>rr","<Plug>(Luadev-Run)ip",opts)
map({"n","v"},"<localleader>rw","<Plug>(Luadev-RunWord)",opts)
map({"n","v"},"<localleader>rc","<Plug>(Luadev-Complete)",opts)
