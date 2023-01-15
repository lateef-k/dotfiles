---@diagnostic disable: undefined-global

local utils = require("utils.sniputils")

local snips = {}

snips.print = utils.wrap_node("print", [[print({wrapped}){exit}]])
snips.pins = utils.wrap_node("pins", [[print(vim.inspect({wrapped})){exit}]])

local ret = {}
for _, v in pairs(snips) do
	table.insert(ret, v)
end
return ret
