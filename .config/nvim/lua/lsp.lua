local check_for_poetry_lock = function()
	local match = vim.fn.glob(vim.fn.getcwd() .. "/poetry.lock")
	if vim.env.VIRTUAL_ENV ~= nil then
		return nil
	end
	if match ~= "" then
		local poetry_venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
		local path_extended = string.format("%s:%s/bin", vim.env.PATH, poetry_venv)
		vim.env.VIRTUAL_ENV = poetry_venv
		vim.env.PATH = path_extended
	end
end

-- Run this before we enable our LSP
check_for_poetry_lock()

local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", { capabilities = capabilities })
-- lsp/lua_ls.lua and lsp/pylsp.lua are loaded automatically by vim.lsp.enable()
-- via Neovim's built-in lsp/ runtimepath discovery
vim.lsp.enable({ "lua_ls", "pylsp", "luasnip", "ty" })

vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
	},
})
