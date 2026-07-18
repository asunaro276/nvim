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
    local function only_fern()
      local wins = vim.tbl_filter(function(w)
        return vim.api.nvim_win_get_config(w).relative == ""
      end, vim.api.nvim_list_wins())
      if #wins ~= 1 then return false end
      return vim.bo[vim.api.nvim_win_get_buf(wins[1])].filetype == "fern"
    end
    if only_fern() then
      vim.defer_fn(function()
        if only_fern() then
          vim.cmd("enew")
        end
      end, 50)
    end
  end,
})

-- fern はツリー表示で行番号を使わないので非表示にする
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fern",
  callback = function()
    vim.opt_local.number = false
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

    -- vimの操作感に寄せる（<Plug>経由なのでremap必須）
    local vim_like_opts = { buffer = true, remap = true, silent = true }
    vim.keymap.set("n", "r", "<Plug>(fern-action-rename)", vim_like_opts)
    vim.keymap.set("n", "A", "<Plug>(fern-action-new-dir)", vim_like_opts)
    vim.keymap.set("n", "y", "<Plug>(fern-action-clipboard-copy)", vim_like_opts)
    vim.keymap.set("n", "p", "<Plug>(fern-action-clipboard-paste)", vim_like_opts)
    vim.keymap.set("n", "d", "<Plug>(fern-action-trash)", vim_like_opts)
    -- fern標準のaction-choiceメニューを "g?" に退避し、"a" をファイル新規作成に使う
    -- （<Space>はmapleaderで<leader>系のプレフィックスとして使っているため避ける、
    -- 　"?" はfernのヘルプ表示のままにしておく）
    -- action-choiceへのマッピングを先に用意しておくと、直後に走る
    -- fern#action#_init() 内の hasmapto() ガードが効いて "a" が上書きされなくなる
    vim.keymap.set("n", "g?", "<Plug>(fern-action-choice)", vim_like_opts)
    vim.keymap.set("n", "a", "<Plug>(fern-action-new-file)", vim_like_opts)

    -- u: trash-put で消したファイルを一覧から選んで復元する（trash-restoreは日付降順で並ぶ）
    vim.keymap.set("n", "u", function()
      vim.cmd("botright new")
      vim.cmd("terminal trash-restore")
      vim.cmd("startinsert")
    end, { buffer = true, silent = true })
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
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
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

local function focus_fern()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "fern" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

local function focus_file()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= "fern" and vim.api.nvim_win_get_config(win).relative == "" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

vim.keymap.set("n", "<leader>0", focus_fern, { silent = true })
vim.keymap.set("n", "<C-0>", focus_fern, { silent = true })
vim.keymap.set("n", "\x1b[0;5~", focus_fern, { silent = true })
vim.keymap.set("n", "<leader>1", focus_file, { silent = true })
vim.keymap.set("n", "<C-1>", focus_file, { silent = true })
vim.keymap.set("n", "\x1b[1;5~", focus_file, { silent = true })
