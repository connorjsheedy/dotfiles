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
vim.lsp.config("lua_ls", require("lsp.lua_ls"))
vim.lsp.config("pylsp", { settings = { pylsp = require("lsp.pylsp") } })
vim.lsp.enable({ "lua_ls", "pylsp", "luasnip", "ty" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		-- LSP navigation keymaps are handled by snacks.nvim pickers (gd, gr, gD, etc.)
		if client:supports_method("textDocument/completion") then
			vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
			vim.lsp.completion.enable(true, client.id, ev.buf, {
				autotrigger = true,
				convert = function(item)
					return { abbr = item.label:gsub("%b()", "") }
				end,
			})
		end
	end,
})

vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
	},
})
