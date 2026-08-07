local function find_root(markers)
	return vim.fs.root(0, markers) or vim.fn.expand("%:p:h")
end

local sub_markers = { "pnpm-workspace.yaml", "nx.json", "lerna.json", "pyproject.toml", "go.mod", "Cargo.toml", "requirements.txt", "package.json", ".git" }

vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files({ cwd = find_root(sub_markers) })
end, { desc = "Find Files" })

vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep({ cwd = find_root(sub_markers) })
end, { desc = "Live Grep" })

vim.keymap.set("n", "<leader>fc", function()
	require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config" })

vim.keymap.set("n", "<leader><leader>", function()
	require("fzf-lua").buffers()
end, { desc = "Open buffers" })

vim.keymap.set("t", "<leader><leader>", function()
	vim.cmd("stopinsert")
	vim.schedule(function()
		require("fzf-lua").buffers()
	end)
end, { desc = "Open buffers" })

vim.keymap.set("n", "<leader>/", function()
	require("fzf-lua").blines()
end, { desc = "Search in buffer" })

