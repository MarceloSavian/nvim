require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

vim.keymap.set("n", "-", "<cmd>Oil --float <CR>", { desc = "Open parent directory" })
