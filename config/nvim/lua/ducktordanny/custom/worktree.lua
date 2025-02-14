local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"

local last_buffer = require "ducktordanny.custom.last_buffer"

local M = {}

---@class WorktreePaths
---@field tree_paths string[]
---@field bare_path string
---@field current_tree string
---@field branch_names string[]

---@type string | nil
M._current_worktree = nil

---@param no_current_tree_text string | nil The text for current tree to return if no worktree is selected.
---@return WorktreePaths
M._get_worktree_paths = function(no_current_tree_text)
  no_current_tree_text = no_current_tree_text or ""
  local project_path = vim.fn.getcwd()
  local worktrees = vim.fn.systemlist "git worktree list"

  local tree_paths = {}
  local branch_names = {}
  local bare_path = ""

  for _, worktree in ipairs(worktrees) do
    local info = {}
    for match in worktree:gmatch "%S+" do
      table.insert(info, match)
    end
    if info[1] ~= project_path and info[2] ~= "(bare)" then
      table.insert(tree_paths, info[1])
      table.insert(branch_names, info[3])
    elseif info[2] == "(bare)" then
      bare_path = info[1]
    end
  end

  local current_tree = no_current_tree_text
  if project_path ~= bare_path and bare_path ~= "" then
    current_tree = project_path:sub(#bare_path + 2)
  end

  return {
    tree_paths = tree_paths,
    bare_path = bare_path,
    current_tree = current_tree,
    branch_names = branch_names,
  }
end

---@param tree_paths string[]
---@param bare_path string
---@param branch_names string[]
---@return string[]
M._get_formated_tree_list = function(tree_paths, bare_path, branch_names)
  local tree_names = {}

  for index, path in ipairs(tree_paths) do
    local name = path:sub(#bare_path + 2)
    table.insert(tree_names, name .. " " .. branch_names[index])
  end

  return tree_names
end

---@param tree_path string
M._handle_worktree_switch = function(tree_path)
  vim.cmd ":wa"
  last_buffer.save_for_current_cwd()
  vim.cmd ":%bd"
  vim.cmd("cd" .. tree_path)
  last_buffer.restore_by_cwd()
  M._current_worktree = nil
end

---Returns the currently selected worktree (from cache).
---@return string
M.get_current_worktree = function()
  if M._current_worktree == nil then
    local worktree_details = M._get_worktree_paths()
    M._current_worktree = worktree_details.current_tree
  end
  return M._current_worktree
end

---@param opts any Telescope opts
M.select_worktree = function(opts)
  opts = opts or {}
  local trees = M._get_worktree_paths "-"
  if #trees.tree_paths == 0 then
    print "You have no worktrees!"
    return
  end
  local tree_names = M._get_formated_tree_list(trees.tree_paths, trees.bare_path, trees.branch_names)

  pickers
      .new(opts, {
        prompt_title = "Worktrees (" .. trees.current_tree .. ")",
        finder = finders.new_table {
          results = tree_names,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            M._handle_worktree_switch(trees.tree_paths[selection.index])
          end)
          return true
        end,
      })
      :find()
end

M.select_worktree_dropdown = function()
  M.select_worktree(themes.get_dropdown {})
end

return M
