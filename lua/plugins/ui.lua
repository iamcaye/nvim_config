vim.cmd.colorscheme('ayu')

require('which-key').setup({
  delay = 0,
  spec = {
    { '<leader>a', group = 'AI' },
    { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
    { '<leader>d', group = 'Document' },
    { '<leader>g', group = 'Git' },
    { '<leader>h', group = 'Hunk/Harpoon' },
    { '<leader>s', group = 'Search' },
    { '<leader>t', group = 'Terminal' },
    { '<leader>u', group = 'UI toggles' },
    { '<leader>w', group = 'Workspace' },
  },
})

require('snacks').setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      { section = 'keys', gap = 1, padding = 1 },
      { section = 'startup', gap = 1, padding = 1 },
      { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 2 },
    },
  },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
    Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
    Snacks.toggle.diagnostics():map('<leader>ud')
    Snacks.toggle.line_number():map('<leader>ul')
    Snacks.toggle.option('conceallevel', {
      off = 0,
      on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
      name = 'Conceal Level',
    }):map('<leader>uc')
    Snacks.toggle.inlay_hints():map('<leader>uh')
    Snacks.toggle.indent():map('<leader>ug')
    Snacks.toggle.dim():map('<leader>uD')
  end,
})

vim.keymap.set('n', '<leader>z', function()
  Snacks.zen()
end, { desc = 'Toggle Zen Mode' })
vim.keymap.set('n', '<leader>Z', function()
  Snacks.zen.zoom()
end, { desc = 'Toggle Zoom' })
vim.keymap.set('n', '<leader>.', function()
  Snacks.scratch()
end, { desc = 'Toggle Scratch Buffer' })
vim.keymap.set('n', '<leader>S', function()
  Snacks.scratch.select()
end, { desc = 'Select Scratch Buffer' })
vim.keymap.set('n', '<leader>n', function()
  Snacks.notifier.show_history()
end, { desc = 'Notification History' })
vim.keymap.set('n', '<leader>bd', function()
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })
