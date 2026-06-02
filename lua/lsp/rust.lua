vim.api.nvim_create_autocmd("FileType", {
	pattern = { "rust" },
	callback = function()
		vim.lsp.start({
			name = "rust-analyzer",
			cmd = { "rust-analyzer" },
			root_dir = vim.fs.root(0, { "Cargo.lock" }) or vim.fs.root(0, { "Cargo.toml" }),
		})
	end,
})
