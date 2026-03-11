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
safe_require("configs.mason")
safe_require("configs.lsp")
safe_require("configs.yazi")
safe_require("configs.telescope")
safe_require("configs.treesitter")
