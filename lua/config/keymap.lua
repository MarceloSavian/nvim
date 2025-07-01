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
