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

vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
	},
})
-- LSP

local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

local default_keymaps = {
	{ keys = "<leader>ca", func = vim.lsp.buf.code_action, desc = "Code Actions" },
	{ keys = "<leader>cr", func = vim.lsp.buf.rename, desc = "Code Rename" },
	{ keys = "<leader>k", func = vim.lsp.buf.hover, desc = "Hover Documentation", has = "hoverProvider" },
	{ keys = "K", func = vim.lsp.buf.hover, desc = "Hover (alt)", has = "hoverProvider" },
	{ keys = "gd", func = vim.lsp.buf.definition, desc = "Goto Definition", has = "definitionProvider" },
}

-- I use blink.cmp for completion, but you can use native completion too

local completion = vim.g.completion_mode or "blink" -- or 'native' for built-in completion

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("lsp_attach"),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local buf = args.buf
		if client then
			-- -- Built-in completion
			-- if completion == "native" and client:supports_method("textDocument/completion") then
			-- 	vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
			-- end

			-- Inlay hints
			if client:supports_method("textDocument/inlayHints") then
				vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
			end

			for _, km in ipairs(default_keymaps) do
				-- Only bind if there's no `has` requirement, or the server supports it
				if not km.has or client.server_capabilities[km.has] then
					vim.keymap.set(
						km.mode or "n",
						km.keys,
						km.func,
						{ buffer = buf, desc = "LSP: " .. km.desc, nowait = km.nowait }
					)
				end
			end
		end
	end,
})

vim.lsp.enable({ "lua_ls", "pylsp", "luasnip", "ty" })

if vim.g.lsp_on_demands then
	vim.lsp.enable(vim.g.lsp_on_demands)
end
