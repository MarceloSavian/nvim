-- Prepend the latest nvm-managed Node to PATH so Copilot and friends find it
-- when nvim is launched from a desktop entry that didn't source the shell.
local nvm_dir = vim.env.NVM_DIR or (vim.env.HOME .. "/.nvm")
local node_bins = vim.fn.glob(nvm_dir .. "/versions/node/*/bin", false, true)
if #node_bins > 0 then
  table.sort(node_bins)
  vim.env.PATH = node_bins[#node_bins] .. ":" .. vim.env.PATH
end

require("config.lazy")
