vim.lsp.config('*', {
  capabilities = require("ddc_source_lsp").make_client_capabilities(),
})

vim.fn["ddc#custom#patch_global"]('ui', 'pum')

vim.fn["ddc#custom#patch_global"]('sources', {'lsp', 'around'})

vim.fn["ddc#custom#patch_global"]('sourceOptions', {
  _ = {
    matchers = {'matcher_fuzzy'},
    sorters = {'sorter_fuzzy'},
    converters = {'converter_fuzzy'},
    minAutoCompleteLength = 1,
  },
  around = {
    mark = 'A',
  },
  lsp = {
    mark = 'LSP',
    maxItems = 15,
  },
})

vim.fn["ddc#enable"]()

vim.keymap.set("i", "<Tab>",
  "<Cmd>call pum#map#insert_relative(1)<CR>",
  { noremap = true, silent = true }
)
vim.keymap.set("i", "<S-Tab>",
  "<Cmd>call pum#map#insert_relative(-1)<CR>",
  { noremap = true, silent = true }
)
vim.keymap.set("i", "<C-y>",
  "<Cmd>call pum#map#confirm()<CR>",
  { noremap = true, silent = true }
)
vim.keymap.set("i", "<C-e>",
  "<Cmd>call pum#map#cancel()<CR>",
  { noremap = true, silent = true }
)

vim.fn['ddc#custom#patch_global'] {
  sourceParams = {
    lsp = {
      snippetEngine = vim.fn['denops#callback#register'](function(body)
        return vim.fn['vsnip#anonymous'](body)
      end),
      enableResolveItem         = true,
      enableAdditionalTextEdit  = true,
      confirmBehavior           = 'replace',
    },
  },
}

vim.keymap.set("n", "<leader>ci", function()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "quickfix" } }
  vim.lsp.buf.code_action(params)
end, { silent = true })
