vim.api.nvim_create_autocmd("FileType", {
	pattern = { "terraform", "terraform-vars", "hcl" },
	callback = function()
		vim.lsp.start({
			name = "terraformls",
			cmd = { "terraform-ls", "serve" },
			root_dir = vim.fs.root(0, { ".terraform", ".git" }),
		})
	end,
})
