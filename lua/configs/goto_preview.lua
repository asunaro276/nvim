require("goto-preview").setup({
  width = 120,
  height = 25,
  border = "rounded",
  default_mappings = false,
})

local gp = require("goto-preview")
vim.keymap.set("n", "gp", gp.goto_preview_definition, { silent = true })
vim.keymap.set("n", "gP", gp.close_all_win, { silent = true })
vim.keymap.set("n", "<Esc>", gp.close_all_win, { silent = true })
