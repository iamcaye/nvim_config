local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Terminal orchestrator (lua/config/terminal.lua): each of split/vsplit/tab/
-- fullscreen is a "slot" that can hold several terminals you cycle through,
-- instead of one window == one terminal.
local term = require('config.terminal')

map('n', '<leader>ts', function()
    term.open('split')
end, { desc = 'Terminal split' })
map('n', '<leader>tv', function()
    term.open('vsplit')
end, { desc = 'Terminal vertical split' })
map('n', '<leader>tt', function()
    term.open('tab')
end, { desc = 'Terminal tab' })
map('n', '<leader>tf', function()
    term.open('fullscreen')
end, { desc = 'Terminal fullscreen buffer' })

map('n', '<leader>tn', function()
    term.new()
end, { desc = 'New terminal in current slot' })
map('n', '<leader>tx', function()
    term.close()
end, { desc = 'Close terminal in current slot' })
map('n', '<leader>tp', function()
    term.pick()
end, { desc = 'Pick terminal' })
map({ 'n', 't' }, '<C-Space>', function()
    term.toggle()
end, { desc = 'Toggle terminal / last non-terminal window' })
map('n', ']t', function()
    term.cycle(1)
end, { desc = 'Next terminal in slot' })
map('n', '[t', function()
    term.cycle(-1)
end, { desc = 'Previous terminal in slot' })

map('n', '<C-A-Up>', '<cmd>resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-A-Down>', '<cmd>resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-A-Left>', '<cmd>vertical resize +2<CR>', { desc = 'Increase window width' })
map('n', '<C-A-Right>', '<cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })

map({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
map('n', '<leader>Y', '"+yy', { desc = 'Yank line to system clipboard' })
map('n', '<leader>P', '"+P', { desc = 'Paste line from system clipboard' })

map('n', '<leader>qn', '<cmd>cnext<CR>', { desc = 'Next quickfix item' })
map('n', '<leader>qp', '<cmd>cprev<CR>', { desc = 'Previous quickfix item' })

map({ 'i', 'c' }, '<C-BS>', '<C-w>', { desc = 'Delete word' })

local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)

local toggle_current_line_comment = function()
  local comment = require('Comment.api')
  comment.toggle.linewise.current()
end

local toggle_visual_line_comment = function()
  local comment = require('Comment.api')
  vim.api.nvim_feedkeys(esc, 'nx', false)
  comment.toggle.linewise(vim.fn.visualmode())
end

map('n', '<C-/>', toggle_current_line_comment, { desc = 'Toggle comment' })
map('n', '<C-_>', toggle_current_line_comment, { desc = 'Toggle comment' })
map('x', '<C-/>', toggle_visual_line_comment, { desc = 'Toggle comment' })
map('x', '<C-_>', toggle_visual_line_comment, { desc = 'Toggle comment' })
