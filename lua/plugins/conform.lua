return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "biome" },
			typescript = { "biome" },
		},
		format_on_save = {
			timeout_ms = 500,
		},
	},
}
