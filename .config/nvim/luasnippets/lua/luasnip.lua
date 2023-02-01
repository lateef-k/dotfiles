---@diagnostic disable: undefined-global

-- https://stackoverflow.com/questions/66382691/how-to-escape-brackets-in-a-multi-line-string-in-lua

local utils = require("utils.snip-utils")

local snips = {}

snips.addsnip = s(
	";snipadd",
	fmt(
		[=[
snips.<> = s("<>", fmt([[
<>
]],
{
    <>
}))
]=],
		{
			i(1),
			rep(1),
			i(2),
			i(3),
		},
		{
			delimiters = "<>",
		}
	)
)

snips.initsnip = s(
	";snipinit",
	fmt(
		[[
---@diagnostic disable: undefined-global
local snips = {{}}

{}

local ret = {{}}
for _, v in pairs(snips) do
	table.insert(ret, v)
end
return ret
]],
		{ i(0) }
	)
)

local ret = {}
for _, v in pairs(snips) do
	table.insert(ret, v)
end
return ret
