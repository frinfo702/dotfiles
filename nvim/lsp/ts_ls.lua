local hints = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = true,
}

-- Formatting goes through biome/prettier (conform), like helix's except-features = ["format"].
return {
  settings = {
    typescript = { inlayHints = hints },
    javascript = { inlayHints = hints },
  },
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
}
