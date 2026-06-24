require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "ts_ls", "cssls", "html", "vue_ls" },
  -- solargraphはlsp.luaで明示的にroot_dirを設定して管理するため除外
  automatic_enable = {
    exclude = { "solargraph" },
  },
})
