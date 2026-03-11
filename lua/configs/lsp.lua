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
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

local servers = { "lua_ls", "ts_ls", "cssls", "html" }
for _, server in ipairs(servers) do
  vim.lsp.config[server] = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  vim.lsp.enable(server)
end
