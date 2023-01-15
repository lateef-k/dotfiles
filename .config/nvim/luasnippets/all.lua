---@diagnostic disable: undefined-global
--

require("utils.sniputils")

local snips = {}

snips.time = s(
	";time",
	fmt([[({})]], {
		p(os.date),
	})
)

local ret = {}
for _, v in pairs(snips) do
	table.insert(ret, v)
end
return ret
