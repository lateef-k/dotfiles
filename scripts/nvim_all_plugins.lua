local lazy = require("lazy")
for _, plugin in pairs(lazy.plugins()) do
	local repo = plugin[1]
	if repo:match("^%w+/%w+$") then -- matches plugins defined as "user/repo"
		print("https://github.com/" .. repo)
	elseif repo:match("github.com") then -- matches full GitHub URLs
		print(repo)
	end
end
