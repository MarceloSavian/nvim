vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	callback = function()
		vim.lsp.start({
			name = "ts_ls",
			cmd = { "typescript-language-server", "--stdio" },
			root_dir = vim.fs.root(0, { "tsconfig.json", "package.json" }),
		})
	end,
})
