require("lazy").setup({
	-- NOTE: First, some plugins that don't require any configuration
	-- Git related plugins
	"tpope/vim-fugitive",
	-- File/project manager
	"ThePrimeagen/harpoon",
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	-- Tmux support
	"aserowy/tmux.nvim",
	"mbbill/undotree",
	{ import = "plugins.snacks" },
	{ import = "plugins.dap" },
	{ import = "plugins.neotest" },
	{ "nvim-mini/mini.nvim", version = "*" },
	-- lazy.nvim
	{
		"nickjvandyke/opencode.nvim",
		version = "*", -- Latest stable release
		dependencies = {
			{
				-- `snacks.nvim` integration is recommended, but optional
				---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
				"folke/snacks.nvim",
				optional = true,
				opts = {
					input = {}, -- Enhances `ask()`
					picker = { -- Enhances `select()`
						actions = {
							opencode_send = function(...)
								return require("opencode").snacks_picker_send(...)
							end,
						},
						win = {
							input = {
								keys = {
									["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
								},
							},
						},
					},
				},
			},
		},
		config = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- Your configuration, if any; goto definition on the type or field for details
			}

			vim.o.autoread = true -- Required for `opts.events.reload`

			-- Recommended/example keymaps
			vim.keymap.set({ "n", "x" }, "<C-a>", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask opencode…" })
			vim.keymap.set({ "n", "x" }, "<C-x>", function()
				require("opencode").select()
			end, { desc = "Execute opencode action…" })
			vim.keymap.set({ "n", "t" }, "<C-.>", function()
				require("opencode").toggle()
			end, { desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "go", function()
				return require("opencode").operator("@this ")
			end, { desc = "Add range to opencode", expr = true })
			vim.keymap.set("n", "goo", function()
				return require("opencode").operator("@this ") .. "_"
			end, { desc = "Add line to opencode", expr = true })

			vim.keymap.set("n", "<S-C-u>", function()
				require("opencode").command("session.half.page.up")
			end, { desc = "Scroll opencode up" })
			vim.keymap.set("n", "<S-C-d>", function()
				require("opencode").command("session.half.page.down")
			end, { desc = "Scroll opencode down" })

			-- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
			vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
			vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
	},
	{ "nvim-mini/mini.surround", version = false },
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				delete_to_trash = true,
				skip_confirm_for_simple_edits = true,
				view_options = {
					show_hidden = true,
					natural_order = true,
					is_always_hidden = function(name, _)
						return name == ".." or name == ".git"
					end,
				},
			})
		end,
	},
	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
			"saghen/blink.cmp",
		},
	},
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				vim.keymap.set(
					"n",
					"<leader>gp",
					require("gitsigns").prev_hunk,
					{ buffer = bufnr, desc = "[G]o to [P]revious Hunk" }
				)
				vim.keymap.set(
					"n",
					"<leader>gn",
					require("gitsigns").next_hunk,
					{ buffer = bufnr, desc = "[G]o to [N]ext Hunk" }
				)
				vim.keymap.set(
					"n",
					"<leader>ph",
					require("gitsigns").preview_hunk,
					{ buffer = bufnr, desc = "[P]review [H]unk" }
				)
				vim.keymap.set(
					"n",
					"<leader>rh",
					require("gitsigns").reset_hunk,
					{ buffer = bufnr, desc = "[R]eset [H]unk" }
				)
			end,
		},
	},
	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				theme = "rose-pine",
				component_separators = "|",
				section_separators = "",
			},
		},
	},
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {},
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			workspaces = {
				{
					name = "work",
					path = "~/ensodata/projects",
				},
			},
		},
		mappings = {
			-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- Toggle check-boxes.
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			-- Smart action depending on context, either follow link or toggle checkbox.
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
		ui = {
			enable = false,
		},
		attachments = {
			img_folder = "assets/imgs",
			---@param client obsidian.Client
			---@param path obsidian.Path the absolute path to the image file
			---@return string
			img_text_func = function(client, path)
				path = client:vault_relative_path(path) or path
				return string.format("![%s](%s)", path.name, path)
			end,
		},
		spec = {
			{ import = "lazyvim.plugins.extras.lang.python" },
		},
		daily_notes = {
			folder = "~/ensodata/projects/daily_notes/",
			default_tags = { "daily_notes" },
		},
	},
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "default" },
			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "pylsp", "ruff", "ty" },
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
}, {})
