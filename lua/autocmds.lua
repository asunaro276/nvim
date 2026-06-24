local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
	pattern = "*",
	command = ":%s/\\s\\+$//e",
})

autocmd("BufEnter", {
	pattern = "*",
	command = "set fo-=c fo-=r fo-=o",
})

-- 非ターミナルウィンドウが全て閉じたらNeovimを終了
autocmd("WinClosed", {
	callback = function()
		vim.schedule(function()
			local non_terminal = vim.tbl_filter(function(w)
				local buf = vim.api.nvim_win_get_buf(w)
				local ft = vim.bo[buf].filetype
				return vim.bo[buf].buftype ~= "terminal" and ft ~= "fern"
			end, vim.api.nvim_list_wins())
			if #non_terminal == 0 then
				vim.cmd("qa!")
			end
		end)
	end,
})

-- ダッシュボードタブだけのタブを、別タブに移動した時に閉じる
autocmd("TabEnter", {
  callback = function()
    local current_tab = vim.api.nvim_get_current_tabpage()
    vim.schedule(function()
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        if tab == current_tab then goto continue end
        local wins = vim.api.nvim_tabpage_list_wins(tab)
        if #wins == 1 then
          local buf = vim.api.nvim_win_get_buf(wins[1])
          local ft = vim.bo[buf].filetype
          if ft == "snacks_dashboard" then
            local tabnr = vim.api.nvim_tabpage_get_number(tab)
            pcall(vim.cmd, tabnr .. "tabclose")
          end
        end
        ::continue::
      end
    end)
  end,
})

autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec('silent! norml! g`"zv', false)
	end,
})
