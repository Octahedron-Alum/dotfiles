local dppSrc = vim.fn.expand("~/.cache/dpp/repos/github.com/Shougo/dpp.vim")
local denopsSrc = vim.fn.expand("~/.cache/dpp/repos/github.com/vim-denops/denops.vim")
local ext_toml = vim.fn.expand("~/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml")
local ext_lazy = vim.fn.expand("~/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy")
local ext_installer = vim.fn.expand("~/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer")
local ext_git = vim.fn.expand("~/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git")

vim.opt.runtimepath:prepend(dppSrc)
vim.opt.runtimepath:append(ext_toml)
vim.opt.runtimepath:append(ext_lazy)
vim.opt.runtimepath:append(ext_installer)
vim.opt.runtimepath:append(ext_git)

local dpp = require("dpp")

local dppBase   = vim.fn.expand("~/.cache/dpp")
local dpp_config = vim.fn.expand("~/.config/nvim/dpp.ts")

if dpp.load_state(dppBase) then

  vim.opt.runtimepath:prepend(denopsSrc)
  dpp.make_state(dppBase, dpp_config)

  dpp.load_state(dppBase)
end

vim.api.nvim_create_autocmd("User", {
  pattern = "Dpp:makeStatePost",
  callback = function()
    vim.notify("dpp make_state() is done")
  end,
})

-- install
vim.api.nvim_create_user_command('DppInstall', "call dpp#async_ext_action('installer', 'install')", {})
-- update
vim.api.nvim_create_user_command(
    'DppUpdate', 
    function(opts)
        local args = opts.fargs
        vim.fn['dpp#async_ext_action']('installer', 'update', { names = args })
    end, 
    { nargs = '*' }
)

vim.cmd("filetype indent plugin on")
vim.cmd("syntax on")

