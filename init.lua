vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local config_dir = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h')
vim.opt.runtimepath:prepend(config_dir)

if vim.fn.has('nvim-0.12') ~= 1 then
  error('This configuration requires Neovim 0.12 or newer.')
end

require('config.options')
require('config.autocmds')
require('config.diagnostics')
require('config.keymaps')
require('config.pack')
require('config.mason')
require('config.lsp')

require('plugins.files')
require('plugins.git')
require('plugins.search')
require('plugins.treesitter')
require('plugins.format')
require('plugins.ui')
require('plugins.statusline')
require('plugins.ai')
require('plugins.debug')
