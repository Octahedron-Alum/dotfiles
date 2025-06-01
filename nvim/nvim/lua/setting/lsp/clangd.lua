vim.lsp.config("clangd", {
  capabilities = require("ddc_source_lsp").make_client_capabilities(),
  cmd = {
    "clangd",
    "--header-insertion=iwyu",
    "--header-insertion-decorators",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
  },
  init_options = {
    clangdFileStatus = true,
    completeUnimported = true,
    usePlaceholders   = true,
  },
})

vim.lsp.enable("clangd")

