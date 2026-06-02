vim.api.nvim_create_autocmd("FileType", {
	pattern = { "robot", "resource" },
	callback = function()
		local root = vim.fs.root(0, { "robot.toml", "pyproject.toml", "requirements.txt", ".git" })
		local cmd = { "/Library/Frameworks/Python.framework/Versions/3.12/bin/robotcode", "language-server" }

		if root then
			local venv_rc = root .. "/.venv/bin/robotcode"
			if vim.fn.executable(venv_rc) == 1 then
				cmd = { venv_rc, "language-server" }
			end
		end

		vim.lsp.start({
			name = "robotcode",
			cmd = cmd,
			root_dir = root,
		})
	end,
})
