vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

local servers = {
  pylsp = {
    plugins = {
      pylint = {
        enabled = true,
      },
      pycodestyle = {
        ignore = {'W391'},
        maxLineLength = 100
      },
      black = {
        enabled = true,  -- Enable the plugin
      },
      ruff = {
        enabled = true,  -- Enable the plugin
        formatEnabled = true,  -- Enable formatting using ruffs formatter
        config = "pyproject.toml",  -- Custom config for ruff to use
        extendSelect = { "I" },  -- Rules that are additionally used by ruff
        extendIgnore = { "C90" },  -- Rules that are additionally ignored by ruff
        format = { "I" },  -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
        severities = { ["D212"] = "I" },  -- Optional table of rules where a custom severity is desired
        unsafeFixes = false,  -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

        -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
        lineLength = 100,  -- Line length to pass to ruff checking and formatting
        select = { "F" },  -- Rules to be enabled by ruff
        ignore = { "D210" },  -- Rules to be ignored by ruff
        perFileIgnores = { ["__init__.py"] = "CPY001" },  -- Rules that should be ignored for specific files
        preview = false,  -- Whether to enable the preview style linting and formatting.
      },
    }
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = {"vim"} },
    },
  },
}
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

      local settings = servers[client.name]
      if type(settings) ~= "table" then
        settings = {}
      end

      local builtin = require "telescope.builtin"

      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
      vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
      vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
      vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

      vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
      vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
      vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })
      -- vim.keymap.set("n", '<leader>rn', vim.lsp.buf.rename, { buffer = 0 })

      -- Override server capabilities
      if settings.server_capabilities then
        for k, v in pairs(settings.server_capabilities) do
          if v == vim.NIL then
            ---@diagnostic disable-next-line: cast-local-type
            v = nil
          end

          client.server_capabilities[k] = v
        end
      end
    end,
  })

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'supermaven' },
  },
}

