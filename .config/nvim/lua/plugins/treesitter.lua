-- Treesitter
local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
	ensure_installed = {
		"python",
		"lua",
		"vim",
		"vimdoc",
		"rust",
		"json",
		"markdown",
		"yaml",
		"toml",
		"query",
		"go",
	},
	auto_install = true,
	highlight = {
		enable = true,
	},
})
