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
vim.lsp.enable({ "lua_ls", "pylsp", "luasnip", "ty" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
			vim.lsp.completion.enable(true, client.id, ev.buf, {
				autotrigger = true,
				convert = function(item)
					return { abbr = item.label:gsub("%b()", "") }
				end,
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
			vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
			vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
			vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
			vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })

			vim.keymap.set("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end)
		end
		-- if not client:supports_method('textDocument/willSaveWaitUntil')
		--     and client:supports_method('textDocument/formatting') then
		--   vim.api.nvim_create_autocmd('BufWritePre', {
		--     group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
		--     buffer = ev.buf,
		--     callback = function()
		--       vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
		--     end,
		--   })
		-- end
	end,
})

vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
	},
})
