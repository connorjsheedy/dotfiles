-- Core vim options
require("options")

-- Install and load all plugins
require("packs")

-- Plugin configs (order matters)
require("plugins.themes")
require("plugins.snacks")
require("plugins.treesitter")
require("plugins.blink")

-- Mason + LSP dependencies
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "pylsp", "ruff", "ty" } })
require("neodev").setup()
require("fidget").setup()

-- LSP setup (depends on blink.cmp)
require("lsp")

-- Plugin configs
require("plugins.gitsigns")
require("plugins.oil")
require("plugins.conform")
require("plugins.tmux")
require("plugins.mini_surround")
require("Comment").setup()
require("ibl").setup()
require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "rose-pine",
		component_separators = "|",
		section_separators = "",
	},
})

-- Keymaps
require("remaps")

-- Deferred plugins (lazy-require pattern or autocmd-based)
require("plugins.dap")
require("plugins.neotest")
require("plugins.obsidian")
