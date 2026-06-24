vim.g["fern#default_hidden"] = 1
vim.g["fern#renderer"] = "nerdfont"

-- 起動時にサイドバーを常に表示
vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    vim.cmd("Fern . -drawer -width=30 -keep")
  end,
})

-- fern が閉じてしまった場合に再表示するための保護
-- ウィンドウが fern だけになったら新しいバッファを開く
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local wins = vim.api.nvim_list_wins()
    if #wins == 1 then
      local buf = vim.api.nvim_win_get_buf(wins[1])
      if vim.bo[buf].filetype == "fern" then
        vim.cmd("enew")
      end
    end
  end,
})

-- fern バッファのキーマップ
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fern",
  callback = function()
    vim.keymap.set("n", "<CR>", function()
      local action = vim.fn["fern#smart#leaf"](
        "<Plug>(fern-action-open)",
        "<Plug>(fern-action-expand)",
        "<Plug>(fern-action-collapse)"
      )
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(action, true, false, true),
        "n", false
      )
    end, { buffer = true })
  end,
})

-- アイコンに色を付ける
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fern" },
  callback = function()
    vim.fn["glyph_palette#apply"]()
  end,
})

-- サイドバーをトグルする共通関数
local function toggle_fern()
  -- fern ウィンドウが開いているか確認
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "fern" then
      vim.cmd("Fern . -reveal=% -drawer -toggle -width=30 -keep")
      return
    end
  end
  vim.cmd("Fern . -reveal=% -drawer -width=30 -keep")
end

-- <C-n> / <C-b> でトグル（VSCode の Ctrl+B 互換）
vim.keymap.set("n", "<C-n>", toggle_fern, { silent = true })
vim.keymap.set("n", "<C-b>", toggle_fern, { silent = true })

-- <C-0> でサイドバーにフォーカス
vim.keymap.set("n", "<C-0>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "fern" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end, { silent = true })
