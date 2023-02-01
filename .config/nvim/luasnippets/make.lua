

---@diagnostic disable: undefined-global
local snips = {}

snips.phony = s("phony", fmt([[
.PHONY: {}
{}:
{}
]],
{
        i(1),
        rep(1),
        i(0)
}))

local ret = {}
for _, v in pairs(snips) do
    table.insert(ret, v)
end
return ret
