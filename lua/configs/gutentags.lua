-- gutentags: ctags 自動更新設定
vim.g.gutentags_ctags_executable = "ctags"

-- プロジェクトルートの判定基準
vim.g.gutentags_project_root = { ".git", "package.json", "Cargo.toml", "go.mod" }

-- 生成する tags ファイルの場所（プロジェクトルートに置く）
vim.g.gutentags_ctags_tagfile = ".tags"

-- 除外パターン
vim.g.gutentags_ctags_extra_args = {
  "--recurse=yes",
  "--exclude=.git",
  "--exclude=node_modules",
  "--exclude=dist",
  "--exclude=.venv",
}

-- tags ファイルを gitignore に自動追加しない（手動管理）
vim.g.gutentags_add_default_project_roots = 0

-- Neovim の tags オプションにも反映
vim.opt.tags:prepend("./.tags")
