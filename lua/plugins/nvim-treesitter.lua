return {
	{ "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate" },
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		---@module 'treesitter-modules'
		---@type ts.mod.UserConfig
		opts = {
			auto_install = true,
			ensure_installed = { "java", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "typescript", "tsx", "javascript" },
			highlight = { enable = true },
			indent = { enable = true },
		},
	},
}
