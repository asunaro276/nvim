-- vim-test の設定
-- テスト実行にNeovimのターミナルを使用
vim.g["test#strategy"] = "neovim"

-- ターミナルを下部に分割して開く
vim.g["test#neovim#start_normal"] = 1

-- JavaScriptのデフォルトランナーをvitestに設定
-- （playwrightより優先させる）
vim.g["test#javascript#runner"] = "vitest"
