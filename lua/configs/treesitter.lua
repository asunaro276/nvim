require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua", "javascript", "typescript", "tsx",
    "html", "css", "json", "markdown", "markdown_inline", "vue",
  },
  highlight = { enable = true },
  indent = { enable = true },
})
