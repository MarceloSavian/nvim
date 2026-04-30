return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
				include_surrounding_whitespace = true,
			},
			swap = {},
		})

		local select = require("nvim-treesitter-textobjects.select")
		local swap = require("nvim-treesitter-textobjects.swap")

		local function map_select(key, capture, desc, group)
			vim.keymap.set({ "x", "o" }, key, function()
				select.select_textobject(capture, group or "textobjects")
			end, { desc = desc })
		end

		map_select("af", "@function.outer", "Select outer function")
		map_select("if", "@function.inner", "Select inner function")
		map_select("ac", "@class.outer", "Select outer class")
		map_select("ic", "@class.inner", "Select inner class")
		map_select("ao", "@comment.outer", "Select outer comment")
		map_select("as", "@local.scope", "Select language scope", "locals")

		vim.keymap.set("n", "<leader>a", function()
			swap.swap_next("@parameter.inner")
		end, { desc = "Swap with next parameter" })
		vim.keymap.set("n", "<leader>z", function()
			swap.swap_previous("@parameter.inner")
		end, { desc = "Swap with previous parameter" })
	end,
}
