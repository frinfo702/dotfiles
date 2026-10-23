-- Knows the Neovim API when editing this config.
return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" } },
      diagnostics = { globals = { "vim", "Snacks", "MiniIcons" } },
    },
  },
}
