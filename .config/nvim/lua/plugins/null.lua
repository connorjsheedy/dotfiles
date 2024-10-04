-- Autosave and format with Black
-- vim.api.nvim_create_autocmd("BufWritePost",
--   {
--     pattern = "*.py",
--     callback = function()
--       vim.lsp.buf.format()
--     end,
--   }
-- )

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.ruff,
  },
})

