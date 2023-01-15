---@diagnostic disable: undefined-global
local snips = {}
snips.addkey = s(
	";addkey",
	fmt(
		[[
    {} = "<Cmd>{}<Cr>"{}
]],
		{
			i(1),
			i(2),
			i(0),
		}
	)
)

local ret = {}
for _, v in pairs(snips) do
	table.insert(ret, v)
end
return ret
