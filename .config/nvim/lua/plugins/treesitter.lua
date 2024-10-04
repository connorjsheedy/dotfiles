-- Treesitter
local treesitter = require "nvim-treesitter.configs"
treesitter.setup {
  ensure_installed = {
    "python",
    "lua",
    "vim",
    "vimdoc",
    "rust",
    "json",
    "markdown",
    "erlang",
    "yaml",
    "toml",
    "query",
    "elixir",
    "go",
  },
  auto_install = true,
  highlight = {
    enable = true
  }
}
