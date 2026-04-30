local function find_root(markers)
	return vim.fs.root(0, markers) or vim.fn.getcwd()
end

local sub_markers = { "package.json", "pyproject.toml", "go.mod", "Cargo.toml" }
local mono_markers = { ".git" }

return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	keys = {
		{
			"<leader>ff",
			function()
				require("fzf-lua").files({ cwd = find_root(sub_markers) })
			end,
			desc = "Find Files (sub-project)",
		},
		{
			"<leader>fF",
			function()
				require("fzf-lua").files({ cwd = find_root(mono_markers) })
			end,
			desc = "Find Files (monorepo root)",
		},
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep({ cwd = find_root(sub_markers) })
			end,
			desc = "Live Grep (sub-project)",
		},
		{
			"<leader>fG",
			function()
				require("fzf-lua").live_grep({ cwd = find_root(mono_markers) })
			end,
			desc = "Live Grep (monorepo root)",
		},
		{
			"<leader>fc",
			function()
				require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find Config",
		},
		{
			"<leader>fh",
			function()
				require("fzf-lua").helptags()
			end,
			desc = "Find Help",
		},
		{
			"<leader>fk",
			function()
				require("fzf-lua").keymaps()
			end,
			desc = "Find Keymaps",
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").builtin()
			end,
			desc = "Find Builtin vim",
		},
		{
			"<leader>fw",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "Find current Word",
		},
		{
			"<leader>fW",
			function()
				require("fzf-lua").grep_cWORD()
			end,
			desc = "Find current WORD",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").resume()
			end,
			desc = "Resume to last find",
		},
		{
			"<leader>fo",
			function()
				require("fzf-lua").oldfiles()
			end,
			desc = "Find Old files",
		},
		{
			"<leader>/",
			function()
				require("fzf-lua").lgrep_curbuf()
			end,
			desc = "[/] Live grep the current buffer",
		},
	},
}
