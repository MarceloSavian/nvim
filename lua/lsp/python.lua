vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.lsp.start({
			name = "pyright",
			cmd = { "pyright-langserver", "--stdio" },
			root_dir = vim.fs.root(0, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" }),
		})
	end,
})
