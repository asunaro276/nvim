local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

keymap('n', '<CR>', 'o<ESC>', { silent = true })
keymap('n', '<S-CR>', 'O<ESC>', { silent = true })
keymap('n', 'gv', 'gT', { silent = true })

-- タブ切り替え
keymap('n', '<Tab>', 'gt', { silent = true })
keymap('n', '<S-Tab>', 'gT', { silent = true })

-- タブを閉じる（最後のタブなら終了）
vim.keymap.set('n', '<C-w>', function()
  if vim.fn.tabpagenr('$') == 1 then
    vim.cmd('q')
  else
    vim.cmd('tabclose')
  end
end, { silent = true })
keymap('n', 'j', 'gj', { silent = true })
keymap('n', 'k', 'gk', { silent = true })
keymap('n', '<S-h>', '0', { silent = true })
keymap('n', '<S-l>', '$', { silent = true })
keymap('n', '+', '<C-a>', { silent = true })
keymap('n', '-', '<C-x>', { silent = true })
keymap('n', 'Y', 'y$', { silent = true })
keymap('n', 'p', ']p', { silent = true })
keymap('n', 'P', ']P', { silent = true })

-- ビジュアルモード
keymap('v', '<S-h>', '0', { silent = true })
keymap('v', '<S-l>', '$', { silent = true })

-- ノーマル・ビジュアル共通
keymap('', 'j', 'gj', { silent = true })
keymap('', 'k', 'gk', { silent = true })

-- 設定ファイルの再読み込み（Windowsパス）
keymap('n', '<Space>s', ':source $HOME/AppData/Local/nvim/init.lua<CR>', { silent = true })

-- VS Codeライクなキーバインド
-- <C-b>: yazi ファイラー (VS Code Cmd+B)
keymap('n', '<C-b>', ':Yazi<CR>', { silent = true })

-- <C-p>: Telescope ファイル検索 (VS Code Cmd+P)
keymap('n', '<C-p>', ':Telescope find_files<CR>', { silent = true })

-- <C-f>: Telescope 全文検索 (VS Code Cmd+Shift+F)
keymap('n', '<C-f>', ':Telescope live_grep<CR>', { silent = true })

-- <C-\>: ターミナルトグル (VS Code Cmd+`)
vim.keymap.set('n', '<C-\\>', function() Snacks.terminal.toggle() end, { silent = true })


-- ウィンドウ移動
keymap('n', '<C-j>', '<C-w>j', { silent = true })
keymap('n', '<C-k>', '<C-w>k', { silent = true })

-- <leader>g: Lazygit
vim.keymap.set('n', '<leader>g', function() Snacks.lazygit() end, { silent = true })

-- <F12>: タグジャンプ (VS Code F12 定義へ移動) - 新しいタブで開く
vim.keymap.set('n', '<F12>', function()
  vim.cmd('tab tag ' .. vim.fn.expand('<cword>'))
end, { silent = true })
vim.keymap.set('n', '<C-]>', function()
  vim.cmd('tab tag ' .. vim.fn.expand('<cword>'))
end, { silent = true })
keymap('n', '<S-F12>', '<C-t>', { silent = true })

-- <leader>b: git blame トグル
keymap('n', '<leader>b', ':BlamerToggle<CR>', opts)

-- vim-test キーバインド
keymap('n', '<leader>tn', ':TestNearest<CR>', opts)
keymap('n', '<leader>tf', ':TestFile<CR>', opts)
keymap('n', '<leader>ts', ':TestSuite<CR>', opts)
keymap('n', '<leader>tl', ':TestLast<CR>', opts)
keymap('n', '<leader>tv', ':TestVisit<CR>', opts)

-- <C-/>: コメントトグル (VS Code Ctrl+/)
-- ※ターミナルによっては <C-/> が <C-_> として送られるため両方設定
vim.keymap.set('n', '<C-/>', 'gcc', { remap = true, silent = true })
vim.keymap.set('v', '<C-/>', 'gc', { remap = true, silent = true })
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true, silent = true })
vim.keymap.set('v', '<C-_>', 'gc', { remap = true, silent = true })
