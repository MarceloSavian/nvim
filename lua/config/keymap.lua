vim.keymap.set("n", "-", "<cmd>Oil --float <CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostic in Float" })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({
		lsp_format = "fallback",
	})
end, { desc = "[C]ode [F]ormat" })

vim.keymap.set("n", "<leader>gha", ":Git add .", { desc = "[G]it[H]ub [A]dd" })
vim.keymap.set("n", "<leader>ghc", ":Git commit -m '", { desc = "[G]it[H]ub [C]ommit" })
vim.keymap.set("n", "<leader>ghp", ":Git push", { desc = "[G]it[H]ub [P]ush" })
vim.keymap.set("n", "<leader>ghu", ":Git pull", { desc = "[G]it[H]ub p[U]ll" })
vim.keymap.set("n", "<leader>gho", ":Git checkout", { desc = "[G]it[H]ub Check[O]ut" })
vim.keymap.set("n", "<leader>ghm", ":Git merge", { desc = "[G]it[H]ub [M]erge" })

vim.keymap.set("n", "<leader>te", function()
	vim.cmd("terminal")
end, { noremap = true, silent = true, desc = "Open terminal" })
vim.keymap.set(
	"t",
	"<Esc><Esc>",
	[[<C-\><C-n>:q<CR>]],
	{ noremap = true, silent = true, desc = "Exit and close terminal" }
)
vim.keymap.set("t", "<leader><leader>", function()
	require("fzf-lua").buffers()
end, { desc = "Open buffers" })

vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })

vim.keymap.set("n", "<F5>", require("dap").continue)
vim.keymap.set("n", "<F10>", require("dap").step_over)
vim.keymap.set("n", "<F11>", require("dap").step_into)
vim.keymap.set("n", "<F12>", require("dap").step_out)
vim.keymap.set("n", "<Leader>b", require("dap").toggle_breakpoint)
vim.keymap.set("n", "<Leader>B", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)

local dap = require("dap")

dap.adapters.node2 = {
	type = "server",
	host = "127.0.0.1",
	port = 9229,
}

dap.configurations.typescript = {
	{
		type = "node2",
		request = "attach",
		name = "Attach to SST",
		address = "127.0.0.1",
		port = 9229,
		localRoot = vim.fn.getcwd(),
		remoteRoot = "/var/task", -- onde a Lambda roda
		protocol = "inspector",
		sourceMaps = true,
	},
}
-- Cole no seu init.lua (ou em lua/jest_block.lua e faça require dele)

local function jest_block()
	local function esc(s)
		s = s or ""
		s = s:gsub("\\", "\\\\"):gsub("'", "\\'")
		return s
	end

	local _input = vim.ui and vim.ui.input
		or function(opts, on_confirm)
			on_confirm(vim.fn.input(opts.prompt or ""))
		end

	_input({ prompt = "describe (pai): " }, function(main)
		if main == nil then
			return
		end
		main = (main == "" and "suite" or main)

		_input({ prompt = "describe (filho): " }, function(sub)
			if sub == nil then
				return
			end
			sub = (sub == "" and "contexto" or sub)

			_input({ prompt = "test (descrição): " }, function(tdesc)
				if tdesc == nil then
					return
				end
				tdesc = (tdesc == "" and "deve ..." or tdesc)

				local bufnr = vim.api.nvim_get_current_buf()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				local curr = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
				local base = curr:match("^%s*") or ""
				local i1, i2, i3, i4 = base, base .. "  ", base .. "    ", base .. "      "

				local lines = {
					i1 .. "describe('" .. esc(main) .. "', () => {",
					i2 .. "describe('" .. esc(sub) .. "', () => {",
					i3 .. "test('" .. esc(tdesc) .. "', () => {",
					i4 .. "// Arrange",
					i4 .. "// Act",
					i4 .. "// Assert",
					i3 .. "});",
					i2 .. "});",
					i1 .. "});",
				}

				vim.api.nvim_buf_set_lines(bufnr, row, row, true, lines)
				-- coloca o cursor dentro do test
				vim.api.nvim_win_set_cursor(0, { row + 3, #i4 })
			end)
		end)
	end)
end

vim.keymap.set("n", "<leader>jt", jest_block, { desc = "Jest: describe + describe + test" })

-- Cole no seu init.lua (ou em lua/jest_block.lua e dê require)

local function jest_single_describe()
	local function esc(s)
		s = s or ""
		s = s:gsub("\\", "\\\\"):gsub("'", "\\'")
		return s
	end

	local _input = vim.ui and vim.ui.input
		or function(opts, on_confirm)
			on_confirm(vim.fn.input(opts.prompt or ""))
		end

	_input({ prompt = "describe (nome): " }, function(main)
		if main == nil then
			return
		end
		main = (main == "" and "suite" or main)

		_input({ prompt = "test (descrição): " }, function(tdesc)
			if tdesc == nil then
				return
			end
			tdesc = (tdesc == "" and "deve ..." or tdesc)

			local bufnr = vim.api.nvim_get_current_buf()
			local row = vim.api.nvim_win_get_cursor(0)[1]
			local curr = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
			local base = curr:match("^%s*") or ""
			local i1, i2, i3 = base, base .. "  ", base .. "    "

			local lines = {
				i1 .. "describe('" .. esc(main) .. "', () => {",
				i2 .. "test('" .. esc(tdesc) .. "', () => {",
				i3 .. "// Arrange",
				i3 .. "// Act",
				i3 .. "// Assert",
				i2 .. "});",
				i1 .. "});",
			}

			vim.api.nvim_buf_set_lines(bufnr, row, row, true, lines)
			-- coloca o cursor na linha do "// Arrange"
			vim.api.nvim_win_set_cursor(0, { row + 2, #i3 })
		end)
	end)
end

vim.keymap.set("n", "<leader>jd", jest_single_describe, { desc = "Jest: describe + test" })

-- Cole no seu init.lua (ou em lua/jest_block.lua e dê require)

local function jest_only_test()
	local function esc(s)
		s = s or ""
		s = s:gsub("\\", "\\\\"):gsub("'", "\\'")
		return s
	end

	local _input = vim.ui and vim.ui.input
		or function(opts, on_confirm)
			on_confirm(vim.fn.input(opts.prompt or ""))
		end

	_input({ prompt = "test (descrição): " }, function(tdesc)
		if tdesc == nil then
			return
		end
		tdesc = (tdesc == "" and "deve ..." or tdesc)

		local bufnr = vim.api.nvim_get_current_buf()
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local curr = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
		local base = curr:match("^%s*") or ""
		local i1, i2 = base, base .. "  "

		local lines = {
			i1 .. "test('" .. esc(tdesc) .. "', () => {",
			i2 .. "// Arrange",
			i2 .. "// Act",
			i2 .. "// Assert",
			i1 .. "});",
		}

		vim.api.nvim_buf_set_lines(bufnr, row, row, true, lines)
		-- coloca o cursor na linha do "// Arrange"
		vim.api.nvim_win_set_cursor(0, { row + 1, #i2 })
	end)
end

vim.keymap.set("n", "<leader>jj", jest_only_test, { desc = "Jest: test" })
