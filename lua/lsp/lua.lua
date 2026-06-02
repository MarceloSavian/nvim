vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua" },
	callback = function()
		vim.lsp.start({
			name = "lua_ls",
			cmd = { "lua-language-server" },
			root_dir = vim.fs.root(0, { ".luarc.json", ".luarc.jsonc", ".git" }),
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					workspace = { library = vim.api.nvim_get_runtime_file("", true) },
					diagnostics = { globals = { "vim" } },
				},
			},
		})
	end,
})
