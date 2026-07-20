require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  current_line_blame = true,
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')
    local snacks = require('snacks')

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end, 'Next git change')

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end, 'Previous git change')

    map({ 'n', 'v' }, '<leader>hs', gitsigns.stage_hunk, 'Stage hunk')
    map({ 'n', 'v' }, '<leader>hr', gitsigns.reset_hunk, 'Reset hunk')
    map('n', '<leader>hS', gitsigns.stage_buffer, 'Stage buffer')
    map('n', '<leader>hR', gitsigns.reset_buffer, 'Reset buffer')
    map('n', '<leader>hp', gitsigns.preview_hunk, 'Preview hunk')
    map('n', '<leader>hb', gitsigns.blame_line, 'Blame line')
    map('n', '<leader>hd', gitsigns.diffthis, 'Diff against index')
    map('n', '<leader>hD', function()
      gitsigns.diffthis('@')
    end, 'Diff against last commit')


    map('n', '<leader>gg', function()
        snacks.lazygit()
    end, 'Lazygit')

  end,
})

require('Comment').setup()
