local link = s(
	"link",
	fmt(
		[=[
    [<>]{<>}
]=],
		{
			i(1, "anchor"),
			i(2, "link"),
		},
		{ delimiters = "<>" }
	)
)

local snips = {
	link,
}

return snips
