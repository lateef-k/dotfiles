local zk = require("zk")
local commands = require("zk.commands")

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
			table.insert(entries, entry)
		end
	else
		table.insert(entries, require("telescope.actions.state").get_selected_entry().path)
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
end

local function delete_zk_files(prompt_bufnr)
	local entries = get_entries(prompt_bufnr)
	local prompt = string.format("Are you sure you want to delete these %s files [y/N)] ", #entries)
	if vim.fn.input({
		prompt = prompt,
		default = "",
	}) == "y" then
		for _, path in ipairs(entries) do
			vim.fn.delete(path)
		end
		zk.index({}, function(stats)
			vim.notify(string.format("zk index removed %s files from the index", vim.inspect(stats.removedCount)))
		end)
		require("telescope.actions").close(prompt_bufnr)
	end
end

--------------------------

local function wrap(inner_fn, ...)
	local passthrough = ...
	return function(prompt_bufnr)
		inner_fn(prompt_bufnr, unpack(passthrough))
	end
end

commands.add("ZkMain", function(options)
	local cursor = capture_cursor_state()
	zk.edit(options, {
		title = "Notes",
		telescope = {
			attach_mappings = function(_, map)
				local mappings = {
					n = {
						["<C-K>"] = delete_zk_files,
						["<C-Y>"] = wrap(insert_links_at_cursor, cursor),
					},
					i = {
						["<C-K>"] = delete_zk_files,
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
end)
