vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		vim.lsp.completion.enable(true, event.data.client_id, event.buf, {
			autotrigger = true,
		})

		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
		end

		map("gd", require("fzf-lua").lsp_definitions, "Go to Definition")
		map("gD", vim.lsp.buf.declaration, "Go to Declaration")
		map("gi", require("fzf-lua").lsp_implementations, "Go to Implementation")
		map("gr", require("fzf-lua").lsp_references, "Go to References")
		map("grn", vim.lsp.buf.rename, "Rename")
		map("gra", vim.lsp.buf.code_action, "Code Action")
		map("K", vim.lsp.buf.hover, "Hover")
		map("gl", function() vim.diagnostic.open_float({ focusable = true, focus = true }) end, "Open Diagnostic")

		vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { buffer = event.buf })
		vim.keymap.set("i", "<CR>", function()
			return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
		end, { buffer = event.buf, expr = true })
		vim.keymap.set("i", "<C-j>", function()
			return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
		end, { buffer = event.buf, expr = true })
		vim.keymap.set("i", "<C-k>", function()
			return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
		end, { buffer = event.buf, expr = true })
		vim.keymap.set("i", "<C-l>", function()
			return vim.fn.pumvisible() == 1 and "<C-y>" or "<C-l>"
		end, { buffer = event.buf, expr = true })
		vim.keymap.set("i", "<C-h>", function()
			return vim.fn.pumvisible() == 1 and "<C-e>" or "<C-h>"
		end, { buffer = event.buf, expr = true })
	end,
})
