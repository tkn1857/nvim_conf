require("remap")
require("config.lazy")
require("config.lsp")
require("config.telescope")
require("config.treesitter")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:2"

vim.diagnostic.config({
  update_in_insert = false,
})
