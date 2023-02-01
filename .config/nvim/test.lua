t = require("telekasten").escape("%")
print(t)




vim.ui.select({ 1, 2, 3 }, {}, function(choice)
    print("choose: " .. choice)
end)

vim.ui.input({}, function(inp)
    print("input " .. inp)
end)

local zk = require("zk")
zk.edit({ tags = { "NOT journal" } })

local a = {}
a["stuff"] = 0
a["stuff"] = 4
print(vim.inspect(a))

vim.cmd(":ZkMain")

vim.cmd("ZkDaily")

vim.tbl_contains(vim.tbl_keys({}), "e")

zk = require("zk")

zk.edit({ created = "today", select = { "title", "absPath" }, tags = { "linux" }, { "journal" } })

print(false and 5 or 10)

zapi = require("zk.api")
if nil then
    print("truthy")
else
    print("false")
end

-- vim.fs.basename(vim.fn.expand("%:p:h")) .. "/" .. vim.fn.expand("%t")

print(vim.fn.expand("%:p:h"))


local zutils = require("zk.util")
local r = zutils.resolve_notebook_path(0)
r = zutils.notebook_root(r)
r = vim.fs.dirname(r)
local s = vim.fn.expand("%:p")
local href = filename:gsub(root, ""):gsub("/", "", n)
print(r)
print(s)
print(string.gsub(s, r, ""))

local root = zutils.resolve_notebook_path(0)
root = zutils.notebook_root(root)
local filename = vim.fn.expand("%:p")
local href = filename:gsub(root, ""):gsub("/", "", n)
zapi.list(nil, { hrefs = { href }, select = { "title", "path" } }, function(err, inp)
    print(href)
    if err then
        vim.notify(err.message, vim.log.levels.ERROR)
        return
    end
    print(#inp)
end)
zapi = require("zk.api")

zapi.list("daily/2023-01-15_0gei.md", { select = { "title", "path" } }, function(err, inp)
    print(currentFilename)
    if err then
        vim.notify(err.message, vim.log.levels.ERROR)
        return
    end
    print(vim.inspect(inp))
    tbl = vim.tbl_map(function(value)
        return value.title
    end, inp)
    vim.ui.select(tbl, {}, print)
end)
