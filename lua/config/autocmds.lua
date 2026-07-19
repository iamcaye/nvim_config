local augroup = function(name)
  return vim.api.nvim_create_augroup('caye_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  desc = 'Highlight yanked text',
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup('terminal'),
  desc = 'Use terminal-friendly local options',
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = 'no'
    vim.cmd.startinsert()
  end,
})
