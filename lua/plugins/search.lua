local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
})

pcall(telescope.load_extension, 'ui-select')

vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search keymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>sG', builtin.git_files, { desc = 'Search git files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search by grep' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Search Telescope pickers' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current word' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Search resume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Search recent files' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Search buffers' })
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = 'Search current buffer' })
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files({ cwd = vim.fn.stdpath('config') })
end, { desc = 'Search Neovim config' })

local harpoon = require('harpoon')
harpoon.setup()

vim.keymap.set('n', '<leader>hm', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon menu' })
vim.keymap.set('n', '<leader>ha', function()
  harpoon:list():add()
end, { desc = 'Harpoon add' })
vim.keymap.set('n', '<leader>hh', function()
  harpoon:list():select(1)
end, { desc = 'Harpoon file 1' })
vim.keymap.set('n', '<leader>hj', function()
  harpoon:list():select(2)
end, { desc = 'Harpoon file 2' })
vim.keymap.set('n', '<leader>hk', function()
  harpoon:list():select(3)
end, { desc = 'Harpoon file 3' })
vim.keymap.set('n', '<leader>hl', function()
  harpoon:list():select(4)
end, { desc = 'Harpoon file 4' })
vim.keymap.set('n', '<leader>hn', function()
  harpoon:list():next()
end, { desc = 'Harpoon next' })
vim.keymap.set('n', '<leader>hp', function()
  harpoon:list():prev()
end, { desc = 'Harpoon previous' })
