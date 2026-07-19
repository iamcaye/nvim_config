local treesitter = require('nvim-treesitter')

treesitter.setup({
  install_dir = vim.fn.stdpath('data') .. '/site',
})

local languages = {
  'bash',
  'c',
  'diff',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'typescript',
  'vim',
  'vimdoc',
}

vim.api.nvim_create_user_command('TSInstallConfigured', function()
  treesitter.install(languages)
end, { desc = 'Install configured Treesitter parsers' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('caye_treesitter', { clear = true }),
  pattern = languages,
  callback = function()
    pcall(vim.treesitter.start)
    if vim.bo.filetype ~= 'ruby' then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
