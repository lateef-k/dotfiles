local M = {}

local scratch_bufnr = nil

function M.open_input_buffer()
	if scratch_bufnr ~= nil then
		return scratch_bufnr
	end

	scratch_bufnr = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_buf_set_name(scratch_bufnr, "rewrite_query")
	vim.api.nvim_buf_set_option(scratch_bufnr, "filetype", "query")

	vim.api.nvim_command("vsplit")
	vim.api.nvim_command("buffer " .. scratch_bufnr)
end

function M.find_bufnr_by_name(name)
	-- Get a list of all buffers
	local buffers = vim.api.nvim_list_bufs()

	-- Iterate through the buffers
	for _, buf in ipairs(buffers) do
		-- Get the name of the buffer
		local buf_name = vim.api.nvim_buf_get_name(buf)

		-- Check if the buffer has the desired name
		if buf_name == name then
			-- Return the bufnr of the buffer
			return vim.api.nvim_buf_get_number(buf)
		end
	end

	-- Return nil if no buffer was found
	return nil
end

return M
