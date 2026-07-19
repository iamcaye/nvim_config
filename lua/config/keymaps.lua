local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '<leader>ts', '<cmd>split term://zsh<CR>', { desc = 'Terminal split' })
map('n', '<leader>tv', '<cmd>vsplit term://zsh<CR>', { desc = 'Terminal vertical split' })
map('n', '<leader>tt', '<cmd>tabnew term://zsh<CR>', { desc = 'Terminal tab' })
map('n', '<leader>tf', '<cmd>edit term://zsh<CR>', { desc = 'Terminal fullscreen buffer' })

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
