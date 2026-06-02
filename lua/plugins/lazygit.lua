vim.keymap.set("n", "<leader>lg", function()
	vim.cmd("LazyGitCurrentFile")
end, { desc = "LazyGit (current file's repo)" })
