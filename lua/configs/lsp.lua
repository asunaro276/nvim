local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_nvim_lsp.default_capabilities()
end

local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<S-F12>", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

-- ts_ls: Vue TypeScript プラグインを追加
vim.lsp.config["ts_ls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
        languages = { "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}
vim.lsp.enable("ts_ls")

-- solargraph: vim.lsp.enableの自動起動が効かないためFileType autocmdで直接起動する
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function(args)
    local fname = vim.api.nvim_buf_get_name(args.buf)
    local root = vim.fs.root(fname, { "Gemfile" }) or vim.fs.root(fname, { ".git" })
    vim.lsp.start({
      name = "solargraph",
      cmd = { "solargraph", "stdio" },
      root_dir = root,
      on_attach = on_attach,
      capabilities = capabilities,
      init_options = { formatting = true },
      settings = { solargraph = { diagnostics = true } },
    })
  end,
})

local servers = { "lua_ls", "cssls", "html", "vue_ls" }
for _, server in ipairs(servers) do
  vim.lsp.config[server] = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  vim.lsp.enable(server)
end
