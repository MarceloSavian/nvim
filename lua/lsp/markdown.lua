vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		vim.lsp.start({
			name = "marksman",
			cmd = { "marksman", "server" },
			root_dir = vim.fs.root(0, { ".marksman.toml", ".git" }),
		})
	end,
})
