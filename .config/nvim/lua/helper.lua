Helper = {}

function Helper.split(str, delim)
    local res = {}
    for match in str:gmatch(string.format("[^%s]+", delim)) do
        table.insert(res, match);
    end
    return res
end

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
-- our picker function: colors

function Helper.ShowAttachedLsp()
    ---@diagnostic disable-next-line: param-type-mismatch
    print(vim.inspect(vim.lsp.get_active_clients()))
end

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- our picker function: colors
local fuzzy_find = function(opts)

    local lines = {}
    local texts = vim.api.nvim_exec('echo system("get_path_line.py")', true)
    lines = vim.split(texts, '\n')

    pickers.new(opts, {
        prompt_title = "colors",
        finder = finders.new_table {
            results = lines
        },
        sorter = conf.generic_sorter(opts),
    }):find()

end


Helper.fzf = function()
    fuzzy_find(require("telescope.themes").get_dropdown {
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                -- print(vim.inspect(selection))
                local res = Helper.split(selection[1], ":")
                if select then
                    vim.api.nvim_exec(":e " .. res[1],false)
                    vim.api.nvim_exec(":" .. res[2],false)
                end
            end)
            return true
        end,
    })
end


return Helper
