require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua", "javascript", "typescript", "tsx",
    "html", "css", "json", "markdown", "vue",
  },
  highlight = { enable = true },
  indent = { enable = true },
})
