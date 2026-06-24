local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    file_ignore_patterns = { "node_modules/", ".git/" },
    mappings = {
      i = { ["<CR>"] = actions.select_tab },
      n = { ["<CR>"] = actions.select_tab },
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
  },
})
