require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "c++",
    "lua",
    "python",
    "javascript",
    "typescript",
    "html",
    "css",
    "json",
    "bash",
  },

  highlight = {
    enable = true,
  },

  indent = {
    enable = true,
  },
})
