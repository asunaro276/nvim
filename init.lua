vim.g.mapleader = " "

require("base")
require("autocmds")
require("options")
require("keymaps")
require("plugins")
local function safe_require(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify("Failed to load " .. mod .. ": " .. err, vim.log.levels.WARN)
  end
end

safe_require("configs.snacks")
safe_require("configs.fern")
safe_require("configs.mason")
safe_require("configs.lsp")
safe_require("configs.telescope")
safe_require("configs.treesitter")
safe_require("configs.gutentags")
safe_require("configs.goto_preview")

-- コメントトグル（Vue等の埋め込み言語対応）
local ctx_ok, ctx = pcall(require, "ts_context_commentstring")
if ctx_ok then
  ctx.setup({
    enable_autocmd = false,
    config = {
      css  = "/* %s */",
      scss = "// %s",
    },
  })
end
local comment_ok, comment = pcall(require, "Comment")
if comment_ok then
  comment.setup({
    pre_hook = ctx_ok
      and require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      or nil,
  })
end
