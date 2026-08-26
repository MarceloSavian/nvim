vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("plugins.config")
require("config.options")
require("config.lsp")
require("config.format")
require("config.keymaps")

require("lsp.typescript")
require("lsp.rust")
require("lsp.robotcode")
require("lsp.python")
require("lsp.lua")
require("lsp.terraform")
require("lsp.markdown")
require("lsp.json")

pcall(require, "local")

vim.cmd.colorscheme("tokyonight-night")
