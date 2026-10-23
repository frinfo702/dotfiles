-- Ported from helix/languages.toml
return {
  settings = {
    python = {
      analysis = {
        venvPath = ".",
        venv = ".venv",
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "off",
        autoImportCompletions = true,
        logLevel = "Error",
        inlayHint = { enable = true },
      },
    },
  },
}
