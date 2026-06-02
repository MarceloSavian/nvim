local function find_bin(name, root)
	if root then
		local local_bin = root .. "/node_modules/.bin/" .. name
		if vim.uv.fs_stat(local_bin) then
			return local_bin
		end
	end
	return vim.fn.executable(name) == 1 and name or nil
end

local function format_js_ts()
	local file = vim.api.nvim_buf_get_name(0)

	local biome_root = vim.fs.root(0, { "biome.json", "biome.jsonc" })
	if biome_root then
		local biome = find_bin("biome", biome_root)
		if biome then
			vim.system({ biome, "format", "--write", file }):wait()
			vim.cmd("checktime")
			return
		end
	end

	local prettier_root = vim.fs.root(0, { ".prettierrc", ".prettierrc.json", ".prettierrc.js", "prettier.config.js" })
	if prettier_root then
		local prettier = find_bin("prettier", prettier_root)
		if prettier then
			vim.system({ prettier, "--write", file }):wait()
			vim.cmd("checktime")
			return
		end
	end

	vim.lsp.buf.format({ async = false })
end

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = format_js_ts,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.rs", "*.lua" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})
