return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			vim.g.copilot_no_tab_map = true
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"zbirenbaum/copilot-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = {
					{ name = "copilot" },
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
			require("copilot_cmp").setup()
		end,
	},
}
