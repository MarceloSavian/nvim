vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc" },
	callback = function()
		vim.lsp.start({
			name = "jsonls",
			cmd = { "vscode-json-language-server", "--stdio" },
			root_dir = vim.fs.root(0, { "package.json", ".git" }),
			init_options = {
				provideFormatter = true,
			},
			settings = {
				json = {
					validate = { enable = true },
					schemas = {
						{
							fileMatch = { "package.json" },
							url = "https://json.schemastore.org/package.json",
						},
					},
				},
			},
		})
	end,
})
