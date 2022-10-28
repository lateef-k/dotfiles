local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local m = extras.m
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

local function append_snip(args, snip)
	local env = snip.env
	local selection = env.LS_SELECT_RAW

	if selection == nil then
		return ""
	end

	return {
		selection[1],
		"\t" .. args[1][1] .. ",",
		unpack(selection, 2, #selection - 1),
		selection[#selection],
	}
end

-- https://stackoverflow.com/questions/66382691/how-to-escape-brackets-in-a-multi-line-string-in-lua
local addsnip = s(
	";addsnip",
	fmt(
		[=[
local <> = s("<>", fmt([[
    <>
]],
    {
    <>
    }))

<>
]=],
		{
			i(1),
			rep(1),
			i(2),
			i(3),
			f(append_snip, { 1 }),
		},
		{
			delimiters = "<>",
		}
	)
)

local initsnip = s(
	"sinit",
	fmt(
		[[
    local snips = {{

    }}

    return snips
]],
		{}
	)
)

local snips = {
	initsnip,
	addsnip,
}

return snips, {}
