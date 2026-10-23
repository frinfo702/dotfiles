-- pyright owns hover; ruff only lints/formats.
return {
  on_init = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
