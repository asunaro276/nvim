require("claude-code").setup({
  window = {
    position = "botright",
    split_ratio = 0.35,
    enter_insert = true,
    hide_numbers = true,
    hide_signcolumn = true,
  },
  refresh = {
    enable = true,
    updatetime = 100,
    timer_interval = 1000,
    show_notifications = true,
  },
  git = {
    use_git_root = true,
  },
  keymaps = {
    toggle = {
      normal = "<C-,>",
      terminal = "<C-,>",
      variants = {
        continue = "<leader>cC",
        verbose = "<leader>cV",
      },
    },
    window_navigation = true,
    scrolling = true,
  },
})
