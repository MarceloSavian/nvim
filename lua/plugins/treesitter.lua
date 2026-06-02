vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "javascript", "tsx", "rust" },
	callback = function()
		vim.treesitter.start()
	end,
})
