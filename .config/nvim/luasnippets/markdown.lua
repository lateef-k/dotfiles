---@diagnostic disable: undefined-global

---@diagnostic disable: undefined-global
local snips = {}

snips.code = s(
    "code",
    fmt(
        [[
```{lang}
{exit}
```
]]       ,
        {
            lang = i(1),
            exit = i(0),
        }
    )
)

snips.shell_liner = s(
    ";shell_one_liner",
    fmt(
        [[
_{}_
```bash
{}
```
{}
]]       ,
        {
            i(1),
            i(2),
            i(0),
        }
    )
)

snips.journal_section = s(
    ";journal_section",
    fmt(
        [[
# ({})
- {}
]]       ,
        {
            p(os.date),
            i(1),
        }
    )
)

local ret = {}
for _, v in pairs(snips) do
    table.insert(ret, v)
end
return ret
