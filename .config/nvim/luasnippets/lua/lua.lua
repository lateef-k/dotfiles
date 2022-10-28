---@diagnostic disable: undefined-global

local utils = require("sniputils")

local print = utils.wrap_node("print", [[print({wrapped}){exit}]])
local pins = utils.wrap_node("pins", [[print(vim.inspect({wrapped})){exit}]])

local snips = {
	print,
	pins,
}

return snips, {}
