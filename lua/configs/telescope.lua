local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function find_fern_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "fern" then
      return win
    end
  end
  return nil
end

-- drawer が ready になってから FernReveal を実行する。
-- `Fern -reveal=...` オプションは複数タブで Fern を併用すると viewer:ready フックが
-- 競合して動かないため、drawer を開いてから別コマンドで reveal する。
local function reveal_in_fern(file_win, filepath, retries)
  retries = retries or 20
  local fern_win = find_fern_win()
  if not fern_win then
    if retries > 0 then
      vim.defer_fn(function() reveal_in_fern(file_win, filepath, retries - 1) end, 50)
    end
    return
  end
  vim.api.nvim_set_current_win(fern_win)
  pcall(vim.cmd, "FernReveal " .. vim.fn.fnameescape(filepath))
  if vim.api.nvim_win_is_valid(file_win) then
    vim.api.nvim_set_current_win(file_win)
  end
end

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
  local filepath = vim.fn.expand("%:p")
  if not find_fern_win() then
    vim.cmd("Fern . -drawer -width=30 -keep")
    vim.api.nvim_set_current_win(file_win)
  end
  vim.defer_fn(function() reveal_in_fern(file_win, filepath) end, 50)
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
