local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

keymap('n', '<CR>', 'o<ESC>', { silent = true })
keymap('n', '<S-CR>', 'O<ESC>', { silent = true })
keymap('n', 'gv', 'gT', { silent = true })
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
keymap('v', '<', '<gv', { silent = true })
keymap('v', '>', '>gv', { silent = true })
keymap('v', '<S-h>', '0', { silent = true })
keymap('v', '<S-l>', '$', { silent = true })

-- ノーマル・ビジュアル共通
keymap('', 'j', 'gj', { silent = true })
keymap('', 'k', 'gk', { silent = true })

-- 設定ファイルの再読み込み（Windowsパス）
keymap('n', '<Space>s', ':source $HOME/AppData/Local/nvim/init.lua<CR>', { silent = true })
