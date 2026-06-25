local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function open_in_tab(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  if not selection then return end
  local filename = selection.path or selection.filename
  if not filename then return end
  pcall(vim.cmd, "tabedit " .. vim.fn.fnameescape(filename))
  if selection.lnum then
    pcall(vim.api.nvim_win_set_cursor, 0, { selection.lnum, (selection.col or 1) - 1 })
  end
  local file_win = vim.api.nvim_get_current_win()
  local has_fern = false
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "fern" then
      has_fern = true
      break
    end
  end
  if not has_fern then
    vim.cmd("Fern . -drawer -width=30 -keep")
  end
  vim.api.nvim_set_current_win(file_win)
  vim.cmd("Fern . -reveal=% -drawer -width=30 -keep")
  vim.api.nvim_set_current_win(file_win)
end

require("telescope").setup({
  defaults = {
    file_ignore_patterns = { "node_modules/", ".git/" },
    mappings = {
      i = { ["<CR>"] = open_in_tab },
      n = { ["<CR>"] = open_in_tab },
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/",
      "--glob=!node_modules/",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--exclude", "node_modules" },
    },
    lsp_references = { jump_type = "tab" },
    lsp_definitions = { jump_type = "tab" },
  },
})
