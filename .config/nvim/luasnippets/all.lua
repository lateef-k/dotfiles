---@diagnostic disable: undefined-global
--

require("sniputils")

local time = s(";time", p(os.date))

local snips = {
	time,
}

return snips
