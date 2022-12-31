---@diagnostic disable: undefined-global

local utils = require("sniputils")

----------------------------------------------------------------------------
-- dynamically add arguments
local function py_init()
	return sn(
		nil,
		c(1, {
			t(""),
			sn(1, {
				t(", "),
				i(1),
				d(2, py_init),
			}),
		})
	)
end

local function to_init_assign(args)
	local tab = {}
	local a = args[1][1]
	if #a == 0 then
		table.insert(tab, t({ "", "\tpass" }))
	else
		local cnt = 1
		for e in string.gmatch(a, " ?([^,]*) ?") do
			if #e > 0 then
				table.insert(tab, t({ "", "\t\tself." }))
				-- use a restore-node to be able to keep the possibly changed attribute name
				-- (otherwise this function would always restore the default, even if the user
				-- changed the name)
				table.insert(tab, r(cnt, tostring(cnt), i(nil, e)))
				table.insert(tab, t(" = "))
				table.insert(tab, t(e))
				cnt = cnt + 1
			end
		end
	end
	return sn(nil, tab)
end

local cl = s(
	"cl",
	fmt(
		[[
class {}:
    def __init__(self{}):{}

    {}
]],
		{
			i(1),
			d(2, py_init),
			d(3, to_init_assign, { 2 }),
			i(0),
		}
	)
)

-- classname -> change choice -> jump 1 -> jump 2 -> jump to expand -> change choice
local function dataclass_elm()
	return sn(
		nil,
		c(1, {
			t(""),
			sn(1, {
				t({ "", "\t" }),
				i(1),
				t(": "),
				i(2),
				d(3, dataclass_elm),
			}),
		})
	)
end

local dc = s(
	"dc",
	fmt(
		[[
@dataclass
class {}:{}
]],
		{
			i(1),
			d(2, dataclass_elm, {}),
		}
	)
)

local ilog = s("ilog", {
	t({"import logging", "logger = logging.getLogger(__name__)"}),
})

local trybreak = utils.wrap_node(
	"trybreak",
	[[
try:
{wrapped}
except Exception as e:
    breakpoint()
    raise e
    {exit}]]
)

local print = utils.wrap_node("print", [[print({wrapped}){exit}]])

local snips = {
	dc,
	cl,
	ilog,
	trybreak,
}

return snips
