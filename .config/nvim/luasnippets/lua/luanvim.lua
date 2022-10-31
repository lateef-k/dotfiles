
--
local addkey = s(
    ";addkey",
    fmt(
        [[
    {} = "<Cmd>{}<Cr>"{}
]]       ,
        {
            i(1),
            i(2),
            i(0),
     }
    )
)

local snips = {
    addkey,
}

return snips
