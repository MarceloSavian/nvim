vim.keymap.set("n", "<leader>te", function()
	local buf_dir = vim.fn.expand("%:p:h")
	if buf_dir:find("/scripts") then
		vim.cmd("lcd " .. vim.fn.fnameescape(buf_dir))
	else
		local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(buf_dir) .. " rev-parse --show-toplevel")[1]
		if vim.v.shell_error == 0 and git_root then
			vim.cmd("lcd " .. vim.fn.fnameescape(git_root))
		end
	end
	vim.cmd("terminal")
end, { noremap = true, silent = true, desc = "Open terminal at git root" })

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>:q<CR>]], { noremap = true, silent = true, desc = "Exit terminal" })

vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })

vim.keymap.set("n", "<leader>fpy", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "File Path Yank (full)" })
