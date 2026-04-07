return {
	{ "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		---@module 'treesitter-modules'
		---@type ts.mod.UserConfig
		opts = {
			auto_install = true,
			ensure_installed = { "java", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
			incremental_selection = {
				enable = true,
				disable = false,
				keymaps = {
					init_selection = "<Enter>",
					node_incremental = "<Enter>",
					scope_incremental = false,
					node_decremental = false,
				},
			},
		},
	},
}
