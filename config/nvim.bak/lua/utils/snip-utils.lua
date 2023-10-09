---@diagnostic disable: lowercase-global
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

M = {}

function M.selected(_, snip)
	local env = snip.env
	-- wrap in a snippet node to allow jumping into if no text select
	return sn(1, { i(1, env.LS_SELECT_RAW) })
end

function M.wrap_node(trigger, str)
	return s(
		trigger,
		fmt(str, {
			wrapped = d(1, M.selected, {}),
			exit = i(0),
		})
	)
end

return M
