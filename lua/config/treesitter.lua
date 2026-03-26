local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok then
  return
end

treesitter.setup({})

local parsers = { "c", "rust", "javascript", "zig", "python" }
if vim.fn.executable("tree-sitter") == 1 then
  treesitter.install(parsers)
else
  vim.schedule(function()
    vim.notify("tree-sitter CLI not found; skipping parser install", vim.log.levels.WARN)
  end)
end
