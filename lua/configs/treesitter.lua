require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua", "javascript", "typescript", "tsx",
    "html", "css", "json", "markdown",
  },
  highlight = { enable = true },
  indent = { enable = true },
})
