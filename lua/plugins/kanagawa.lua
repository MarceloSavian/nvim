return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({
			transparent = false,
			overrides = function(colors)
				return {
					["@function"] = { fg = colors.palette.crystalBlue },
					["@function.method"] = { fg = colors.palette.crystalBlue },
					["@function.call"] = { fg = colors.palette.crystalBlue },
					["@function.method.call"] = { fg = colors.palette.crystalBlue },
					["@lsp.type.function"] = { fg = colors.palette.crystalBlue },
					["@lsp.type.method"] = { fg = colors.palette.crystalBlue },
					["@lsp.typemod.function.declaration"] = { fg = colors.palette.crystalBlue },
					["@lsp.typemod.method.declaration"] = { fg = colors.palette.crystalBlue },
					["@lsp.typemod.function.definition"] = { fg = colors.palette.crystalBlue },
					["@lsp.typemod.method.definition"] = { fg = colors.palette.crystalBlue },
					["@lsp.type.member"] = { fg = colors.palette.crystalBlue },
					["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
					["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
					["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
					["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
					["@markup.list.markdown"] = { link = "Function" }, -- + list
					["@markup.quote.markdown"] = { link = "Error" }, -- > blockcode
					["@markup.list.checked.markdown"] = { link = "WarningMsg" }, -- - [X] checked list item
				}
			end,
		})
		vim.cmd("colorscheme kanagawa")
	end,
	build = function()
		vim.cmd("KanagawaCompile")
	end,
}
