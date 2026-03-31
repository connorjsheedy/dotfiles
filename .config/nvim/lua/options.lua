vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.o.conceallevel = 1

-- [[ Setting options ]]

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		local excluded_ft = { "lua", "python", "javascript", "rust" }
		local current_ft = vim.bo.filetype

		-- Check if current filetype is in the excluded list
		local is_excluded = false
		for _, ft in ipairs(excluded_ft) do
			if ft == current_ft then
				is_excluded = true
				break
			end
		end

		if not is_excluded then
			vim.opt_local.wrap = true
		end
	end,
})
vim.o.tw = 100
vim.opt.colorcolumn = "100"
