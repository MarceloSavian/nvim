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

vim.keymap.set("n", "<leader>t", function()
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
		skipFiles = { "<node_internals>/**", "node_modules/**" },
	},
}
