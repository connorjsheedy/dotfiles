-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap half-page up and down to include auto center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Oil setup and mappings
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Harpoon keymaps
local harpoon_ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>m", require("harpoon.mark").add_file, { desc = "[H]arpoon [M]ark file" })
vim.keymap.set("n", "<leader>hu", harpoon_ui.toggle_quick_menu, { desc = "[H]arpoon [U]I Toggle Quick View" })
vim.keymap.set("n", "<leader>1", function()
	harpoon_ui.nav_file(1)
end, { desc = "Navigate to Harpoon File 1" })
vim.keymap.set("n", "<leader>2", function()
	harpoon_ui.nav_file(2)
end, { desc = "Navigate to Harpoon File 2" })
vim.keymap.set("n", "<leader>3", function()
	harpoon_ui.nav_file(3)
end, { desc = "Navigate to Harpoon File 3" })
vim.keymap.set("n", "<leader>4", function()
	harpoon_ui.nav_file(4)
end, { desc = "Navigate to Harpoon File 4" })

-- UndoTree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle) -- Config Lua Line

--Custom Remaps
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") --Config Lua Line
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") --Config Lua Line

vim.keymap.set("x", "<leader>pp", '"_dP') --Config Lua Line
