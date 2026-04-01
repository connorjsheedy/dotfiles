local gh = function(x)
	return "https://github.com/" .. x
end

vim.pack.add({
	-- UI / Core
	{ src = gh("rose-pine/neovim"), name = "rose-pine" },
	gh("folke/snacks.nvim"),
	gh("nvim-tree/nvim-web-devicons"),

	-- Git
	gh("tpope/vim-fugitive"),
	gh("lewis6991/gitsigns.nvim"),

	-- Navigation / Files
	gh("ThePrimeagen/harpoon"),
	gh("stevearc/oil.nvim"),
	gh("mbbill/undotree"),

	-- Editor behavior
	gh("tpope/vim-sleuth"),
	gh("numToStr/Comment.nvim"),
	gh("lukas-reineke/indent-blankline.nvim"),
	gh("aserowy/tmux.nvim"),

	-- Mini (monorepo)
	{ src = gh("nvim-mini/mini.nvim"), version = vim.version.range("0") },

	-- Treesitter
	gh("nvim-treesitter/nvim-treesitter"),
	gh("nvim-treesitter/nvim-treesitter-textobjects"),

	-- Completion
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1") },
	gh("rafamadriz/friendly-snippets"),

	-- LSP ecosystem
	gh("neovim/nvim-lspconfig"),
	gh("mason-org/mason.nvim"),
	gh("mason-org/mason-lspconfig.nvim"),
	{ src = gh("j-hui/fidget.nvim"), version = "legacy" },
	gh("folke/neodev.nvim"),

	-- DAP / Test
	gh("mfussenegger/nvim-dap"),
	gh("rcarriga/nvim-dap-ui"),
	gh("nvim-neotest/nvim-nio"),
	gh("nvim-neotest/neotest"),
	gh("nvim-neotest/neotest-python"),
	gh("nvim-lua/plenary.nvim"),

	-- Obsidian
	{ src = gh("epwalsh/obsidian.nvim"), version = vim.version.range("3") },

	-- Status line
	gh("nvim-lualine/lualine.nvim"),

	-- Formatting
	gh("stevearc/conform.nvim"),
})

-- Treesitter build hook
vim.api.nvim_create_autocmd("User", {
	pattern = "PackChanged",
	callback = function(ev)
		if ev.data and ev.data.spec and ev.data.spec.name == "nvim-treesitter" then
			vim.cmd("TSUpdate")
		end
	end,
})
