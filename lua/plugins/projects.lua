local base = vim.fn.expand("~/Documents/projects")

local function scan_dir(path, exclude)
	local items = {}
	if not vim.uv.fs_stat(path) then
		return items
	end
	local handle = vim.uv.fs_scandir(path)
	if not handle then
		return items
	end
	while true do
		local name, ftype = vim.uv.fs_scandir_next(handle)
		if not name then
			break
		end
		if ftype == "directory" and not (exclude and exclude[name]) then
			table.insert(items, name)
		end
	end
	table.sort(items)
	return items
end

local function build_list()
	local entries = {}

	local function header(label)
		local display = string.format("\27[1;34m  ▸ %s\27[0m", label)
		table.insert(entries, "|" .. display)
	end

	local function project(display, path)
		table.insert(entries, path .. "|    " .. display)
	end

	local work_ex = {
		worktrees = true,
		["readmes-ai"] = true,
		emp = true,
		scripts = true,
		testdata = true,
	}

	header("work")
	for _, name in ipairs(scan_dir(base .. "/work", work_ex)) do
		project("work/" .. name, base .. "/work/" .. name)
	end

	header("worktrees")
	local wt_base = base .. "/work/worktrees"
	for _, id in ipairs(scan_dir(wt_base, nil)) do
		for _, proj in ipairs(scan_dir(wt_base .. "/" .. id, nil)) do
			project("worktrees/" .. id .. "/" .. proj, wt_base .. "/" .. id .. "/" .. proj)
		end
	end

	header("readmes-ai")
	for _, name in ipairs(scan_dir(base .. "/work/readmes-ai", nil)) do
		project("readmes-ai/" .. name, base .. "/work/readmes-ai/" .. name)
	end

	header("personal")
	for _, name in ipairs(scan_dir(base .. "/personal", nil)) do
		project("personal/" .. name, base .. "/personal/" .. name)
	end

	local pwt = base .. "/personal/worktrees"
	if vim.uv.fs_stat(pwt) then
		header("personal worktrees")
		for _, id in ipairs(scan_dir(pwt, nil)) do
			for _, proj in ipairs(scan_dir(pwt .. "/" .. id, nil)) do
				project("personal/worktrees/" .. id .. "/" .. proj, pwt .. "/" .. id .. "/" .. proj)
			end
		end
	end

	return entries
end

local function open_projects()
	require("fzf-lua").fzf_exec(build_list(), {
		prompt = "  Projects> ",
		winopts = {
			title = " Projects ",
			title_pos = "center",
			height = 0.85,
			width = 0.45,
			preview = { hidden = "hidden" },
		},
		fzf_opts = {
			["--no-sort"] = "",
			["--ansi"] = "",
			["--delimiter"] = "|",
			["--with-nth"] = "2..",
		},
		actions = {
			["default"] = function(selected)
				if not selected or not selected[1] then
					return
				end
				local path = selected[1]:match("^([^|]+)|")
				if not path or path == "" then
					return
				end
				vim.cmd("cd " .. vim.fn.fnameescape(path))
				local readme = nil
				for _, name in ipairs({ "README.md", "README.MD", "readme.md", "README" }) do
					if vim.uv.fs_stat(path .. "/" .. name) then
						readme = path .. "/" .. name
						break
					end
				end
				if readme then
					vim.cmd("edit " .. vim.fn.fnameescape(readme))
				else
					require("oil").open(path)
				end
			end,
		},
	})
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		if vim.fn.argc() == 0 then
			vim.schedule(open_projects)
		end
	end,
})

local function get_buf_project(filepath)
	if not filepath or filepath == "" then
		return nil, nil
	end
	local wt_id, wt_proj, wt_rest = filepath:match("^" .. base .. "/work/worktrees/([^/]+)/([^/]+)(.*)")
	if wt_id then
		return "worktrees/" .. wt_id .. "/" .. wt_proj, wt_rest:gsub("^/", "")
	end
	local rai_folder, rai_rest = filepath:match("^" .. base .. "/work/readmes%-ai/([^/]+)(.*)")
	if rai_folder then
		return "readmes-ai/" .. rai_folder, rai_rest:gsub("^/", "")
	end
	local work_proj, work_rest = filepath:match("^" .. base .. "/work/([^/]+)(.*)")
	if work_proj then
		return "work/" .. work_proj, work_rest:gsub("^/", "")
	end
	local pwt_id, pwt_proj, pwt_rest = filepath:match("^" .. base .. "/personal/worktrees/([^/]+)/([^/]+)(.*)")
	if pwt_id then
		return "personal worktrees/" .. pwt_id .. "/" .. pwt_proj, pwt_rest:gsub("^/", "")
	end
	local pers_proj, pers_rest = filepath:match("^" .. base .. "/personal/([^/]+)(.*)")
	if pers_proj then
		return "personal/" .. pers_proj, pers_rest:gsub("^/", "")
	end
	return nil, vim.fn.fnamemodify(filepath, ":~")
end

local function open_buffers()
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })
	local grouped = {}
	local group_order = {}
	local other = {}

	for _, buf in ipairs(buffers) do
		local project, rel = get_buf_project(buf.name)
		if project then
			if not grouped[project] then
				grouped[project] = {}
				table.insert(group_order, project)
			end
			local rel_part = rel ~= "" and rel or vim.fn.fnamemodify(buf.name, ":t")
			local display = project .. "/" .. rel_part
			table.insert(grouped[project], { bufnr = buf.bufnr, display = display })
		else
			local display = rel ~= "" and rel or vim.fn.fnamemodify(buf.name, ":t")
			table.insert(other, { bufnr = buf.bufnr, display = display })
		end
	end

	table.sort(group_order)

	local entries = {}

	local function header(label)
		local h = string.format("\27[1;34m  ▸ %s\27[0m", label)
		table.insert(entries, "|" .. h)
	end

	for _, proj in ipairs(group_order) do
		header(proj)
		for _, buf in ipairs(grouped[proj]) do
			local modified = vim.bo[buf.bufnr].modified and " ●" or ""
			table.insert(entries, tostring(buf.bufnr) .. "|    " .. buf.display .. modified)
		end
	end

	if #other > 0 then
		header("other")
		for _, buf in ipairs(other) do
			local modified = vim.bo[buf.bufnr].modified and " ●" or ""
			table.insert(entries, tostring(buf.bufnr) .. "|    " .. buf.display .. modified)
		end
	end

	if #entries == 0 then
		vim.notify("No open buffers", vim.log.levels.INFO)
		return
	end

	require("fzf-lua").fzf_exec(entries, {
		prompt = "  Buffers> ",
		winopts = {
			title = " Buffers ",
			title_pos = "center",
			height = 0.6,
			width = 0.55,
			preview = { hidden = "hidden" },
		},
		fzf_opts = {
			["--no-sort"] = "",
			["--ansi"] = "",
			["--delimiter"] = "|",
			["--with-nth"] = "2..",
		},
		actions = {
			["default"] = function(selected)
				if not selected or not selected[1] then
					return
				end
				local bufnr_str = selected[1]:match("^([^|]+)|")
				if not bufnr_str or bufnr_str == "" then
					return
				end
				local bufnr = tonumber(bufnr_str)
				if bufnr then
					vim.api.nvim_set_current_buf(bufnr)
				end
			end,
		},
	})
end

vim.keymap.set("n", "<leader>p", open_projects, { desc = "Open Projects" })
vim.keymap.set("n", "<leader><leader>", open_buffers, { desc = "Find Buffers by Project" })

return {}
