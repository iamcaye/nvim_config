vim.g.copilot_enabled = false

local sidekick_ok, sidekick = pcall(require, 'sidekick')
if sidekick_ok then
  sidekick.setup({
    cli = {
      mux = {
        backend = 'zellij',
        enabled = true,
      },
    },
  })
end

local nes_ok, nes = pcall(require, 'sidekick.nes')
if nes_ok then
  nes.disable()
end

vim.keymap.set('n', '<leader>cp', function()
  vim.g.copilot_enabled = not vim.g.copilot_enabled
  if nes_ok then
    if vim.g.copilot_enabled then
      nes.enable()
    else
      nes.disable()
    end
  end
  vim.notify('Copilot ' .. (vim.g.copilot_enabled and 'enabled' or 'disabled'))
end, { desc = 'Toggle Copilot' })

if sidekick_ok then
  vim.keymap.set({ 'n', 'v' }, '<leader>aa', function()
    require('sidekick.cli').toggle()
  end, { desc = 'Sidekick toggle CLI' })
  vim.keymap.set('n', '<leader>as', function()
    require('sidekick.cli').select()
  end, { desc = 'Sidekick select CLI' })
  vim.keymap.set('v', '<leader>as', function()
    require('sidekick.cli').send({ selection = true })
  end, { desc = 'Sidekick send visual selection' })
  vim.keymap.set({ 'n', 'v' }, '<leader>ap', function()
    require('sidekick.cli').prompt()
  end, { desc = 'Sidekick select prompt' })
  vim.keymap.set({ 'n', 'x', 'i', 't' }, '<C-.>', function()
    require('sidekick.cli').focus()
  end, { desc = 'Sidekick switch focus' })
end
