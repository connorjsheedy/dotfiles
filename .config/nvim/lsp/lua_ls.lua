return {
  cmd = {"lua-language-server"},
  filetypes = { "lua" },
  root_markers = {{ '.luarc.json', '.luarc.jsonrc' }, ".git"},
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
    }
  }
}
