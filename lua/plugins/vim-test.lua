return {
	"vim-test/vim-test",
	config = function()
		-- Optional: Use `neovim/nvim-lspconfig` or set up output to a split
		vim.g["test#strategy"] = "toggleterm" -- or "neovim", "vimux", "basic", etc.

		-- (For TypeScript/Jest users, make sure jest is used)
		vim.g["test#javascript#runner"] = "jest"
		vim.g["test#javascript#jest#executable"] = "npx jest"

		-- Recognize any file in 'test/' folder as a test file (for JavaScript and TypeScript)
		vim.g["test#javascript#jest#test_file_patterns"] = { "%.ts$" }
		vim.g["test#typescript#jest#test_file_patterns"] = { "%.ts$" } -- Keymaps (you can change to your preference)

		vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { desc = "Test nearest" })
		vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "Test file" })
		vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>", { desc = "Test suite" })
		vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "Test last" })
		vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { desc = "Visit last test" })
	end,
}
