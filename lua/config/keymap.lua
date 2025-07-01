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
	vim.cmd("split | terminal")
end, { noremap = true, silent = true, desc = "Open terminal in horizontal split" })
vim.keymap.set(
	"t",
	"<Esc><Esc>",
	[[<C-\><C-n>:q<CR>]],
	{ noremap = true, silent = true, desc = "Exit and close terminal" }
)
