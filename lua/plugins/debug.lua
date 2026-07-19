local dap_ok, dap = pcall(require, 'dap')
local dapui_ok, dapui = pcall(require, 'dapui')

if not (dap_ok and dapui_ok) then
  return
end

dapui.setup({
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
})

vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug start/continue' })
vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug step into' })
vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug step over' })
vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug step out' })
vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug UI toggle' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug toggle breakpoint' })
vim.keymap.set('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Debug conditional breakpoint' })

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

pcall(function()
  require('dap-go').setup({
    delve = {
      detached = vim.fn.has('win32') == 0,
    },
  })
end)
