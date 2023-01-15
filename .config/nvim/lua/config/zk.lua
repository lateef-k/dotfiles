local zk = require("zk")
local zutils = require("zk.util")
local commands = require("zk.commands")
local zapi = require("zk.api")

local function capture_cursor_state()
	local pos = vim.api.nvim_win_get_cursor(0)
	return {
		bufnr = vim.api.nvim_get_current_buf(),
		row = pos[1] - 1,
		col = pos[2],
	}
end

local function get_entries(prompt_bufnr)
	local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
	local entries = {}
	if #picker:get_multi_selection() > 0 then
		for _, entry in ipairs(picker:get_multi_selection()) do
			table.insert(entries, entry.value)
		end
	else
		table.insert(entries, require("telescope.actions.state").get_selected_entry().value)
	end
	return entries
end

-- Commands
--------------------------

local function insert_links_at_cursor(prompt_bufnr, cursor)
	local entries = get_entries(prompt_bufnr)
	for i, entry in pairs(entries) do
		entries[i] = string.format("[%s](%s)", entry.title, entry.path)
	end
	vim.api.nvim_buf_set_text(cursor.bufnr, cursor.row, cursor.col, cursor.row, cursor.col, entries)
	require("telescope.actions").close(prompt_bufnr)
end

local function delete_zk_files_ts(prompt_bufnr)
	local entries = get_entries(prompt_bufnr)
	local prompt = string.format("Are you sure you want to delete these %s files [y/N)] ", #entries)
	if vim.fn.input({
		prompt = prompt,
		default = "",
	}) == "y" then
		for _, entry in ipairs(entries) do
			vim.fn.delete(entry.absPath)
		end
		zk.index({}, function(stats)
			vim.notify(string.format("zk index removed %s files from the index", vim.inspect(stats.removedCount)))
		end)
	end
end

--------------------------

local function wrap(inner_fn, ...)
	local passthrough = ...
	return function(prompt_bufnr)
		inner_fn(prompt_bufnr, passthrough)
	end
end

function zk_interact(options)
	local cursor = capture_cursor_state()
	zk.edit(options, {
		title = "Notes",
		telescope = {
			attach_mappings = function(_, map)
				local mappings = {
					n = {
						["<C-K>"] = delete_zk_files_ts,
						["<C-Y>"] = wrap(insert_links_at_cursor, cursor),
					},
					i = {
						["<C-K>"] = delete_zk_files_ts,
						["<C-Y>"] = wrap(insert_links_at_cursor, cursor),
					},
				}
				for mode, tbl in pairs(mappings) do
					for key, action in pairs(tbl) do
						map(mode, key, action)
					end
				end
				return true
			end,
		},
	})
end

commands.add("ZNotes", function(options)
	options = vim.tbl_deep_extend("force", { "NOT journal" }, options or {})
	zk_interact(options)
end)

commands.add("ZAll", function(options)
	zk_interact(options)
end)

commands.add("ZJournal", function(options)
	options = vim.tbl_deep_extend("force", { hrefs = { "daily" } }, options or {})
	zk_interact(options)
end)

local function count_journals(inp)
	local tbl = {}
	for _, v in ipairs(inp) do
		if vim.tbl_contains(vim.tbl_keys(tbl), v.title) then
			tbl[v.title] = tbl[v.title] + 1
		else
			tbl[v.title] = 1
		end
	end
	return tbl
end

local function get_today_note(choice)
	zapi.list(
		nil,
		{ created = "today", select = { "title", "absPath" }, tags = { choice.title, "journal" } },
		function(err, inp)
			if vim.tbl_isempty(inp) then
				zk.new({ dir = "daily", title = choice.title })
			else
				zk.edit({ created = "today", tags = { choice.title, "journal" } }, { title = "today" })
			end
		end
	)
end

commands.add("ZJournalNew", function()
	zapi.list(nil, { hrefs = { "daily" }, select = { "title", "tags", "path" } }, function(err, inp)
		if err then
			vim.notify(err.message, vim.log.levels.ERROR)
			return
		end
		local tbl = count_journals(inp)
		local choices = {}

		table.insert(choices, { title = "New journal.." })
		for k, v in pairs(tbl) do
			table.insert(choices, { title = k, count = v })
		end

		vim.ui.select(choices, {
			format_item = function(item)
				return item.title .. ((item.count ~= nil) and (" : " .. item.count) or "")
			end,
		}, function(choice, id)
			if choice == nil then
				return
			end
			if id == 1 then
				vim.ui.input({}, function(title)
					zk.new({ dir = "daily", title = title })
				end)
			else
				get_today_note(choice)
			end
		end)
	end)

	-- zk.new uses dir instead of hrefs to specify path (cause href can be a table)
	-- vim.ui.input({}, function (title)
	--     zk.new({ dir = "daily", title =title}) -- no need to have zk.new({dir="daily",group="daily"})
end)

local function get_path_relative_to_notebook(abs_path)
	local root = zutils.resolve_notebook_path(0)
	root = zutils.notebook_root(root)
	return abs_path:gsub(root, ""):gsub("/", "", 1)
end

commands.add("ZLinkCurrent", function()
	local href = get_path_relative_to_notebook(vim.fn.expand("%:p"))
	zapi.list(nil, { hrefs = { href }, select = { "title", "path" } }, function(err, inp)
		if err then
			vim.notify(err.message, vim.log.levels.ERROR)
			return
		end
		inp = inp[1]
		vim.fn.setreg("+", string.format("[%s](%s)", inp.title, inp.path))
	end)
end)
