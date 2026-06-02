require("mason").setup()

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

local ensure_installed = {
	"typescript-language-server",
}

local registry = require("mason-registry")
registry.refresh(function()
	for _, name in ipairs(ensure_installed) do
		local ok, pkg = pcall(registry.get_package, name)
		if ok and not pkg:is_installed() then
			pkg:install()
		end
	end
end)
