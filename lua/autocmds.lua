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
				return vim.bo[buf].buftype ~= "terminal"
			end, vim.api.nvim_list_wins())
			if #non_terminal == 0 then
				vim.cmd("qa!")
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
