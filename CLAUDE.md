# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

個人のNeovim設定リポジトリ(Lua製)。VS Codeライクな操作感(`<C-p>`/`<C-f>`/`<C-b>`など)とタブ中心のワークフローを重視している。

## 動作確認コマンド

自動テストはない。変更後は起動エラーの有無で確認する:

```bash
nvim --headless "+q"          # 起動時のエラー確認(エラーがあれば標準エラーに出る)
nvim --headless "+checkhealth" "+q"
```

Neovim内での確認:
- `:PackerSync` — プラグインの追加・削除を反映(`lua/plugins.lua` 保存時はautocmdで自動実行される)
- `:Mason` — LSPサーバーの管理

## 構成

読み込み順は `init.lua` が起点:

1. `lua/base.lua` → `autocmds.lua` → `options.lua` → `keymaps.lua` → `plugins.lua`(packerのプラグイン宣言)
2. その後 `lua/configs/*.lua` を `safe_require` で読み込み(失敗しても警告のみで起動は継続)

- **プラグイン追加**: `lua/plugins.lua` に `use({...})` を追記。設定が必要なら `lua/configs/<name>.lua` を作成し、`init.lua` の `safe_require` に追加する(claude_code・vim_testのようにpackerの `config` で読む例外もある)
- **`plugin/packer_compiled.lua` は自動生成**。手動編集しない
- キーマップは共通のものが `lua/keymaps.lua`、プラグイン固有のものは各 `configs/*.lua` 内(fernのトグル等)に分散している

## アーキテクチャ上の要点

- **タブ中心のワークフロー**: Telescopeの `<CR>` は独自アクション `open_in_tab`(`configs/telescope.lua`)で新規タブで開き、fern drawerに `FernReveal` する。LSPジャンプも `jump_type = "tab"`。タブ・ウィンドウ管理のautocmd(ダッシュボードタブの自動クローズ等)は `lua/autocmds.lua` にある
- **fern drawer は常時表示が前提**: VimEnterで自動的に開き、fernだけになったら `enew` する保護がある(`configs/fern.lua`)。fern関連を変更する際はこの前提を壊さないこと
- **LSPは新API(`vim.lsp.config` / `vim.lsp.enable`)を使用**(`configs/lsp.lua`)。例外が2つ:
  - `ts_ls` はVue対応のため `@vue/typescript-plugin` を注入し、vueファイルも担当
  - `solargraph` は `vim.lsp.enable` の自動起動が効かないため、FileType autocmdで `vim.lsp.start` を直接呼ぶ(masonの `automatic_enable` からも除外)
- **ctags併用**: LSP非対応ファイル向けにgutentagsで `.tags` を自動生成し、`<C-]>` でタブジャンプする

## 記述スタイル

- コメントは日本語で書く(既存コードに合わせる)
- 「なぜそうしているか」(ワークアラウンドの理由等)のコメントを重視する
