require('conform').setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disabled = { c = true, cpp = true }
    if disabled[vim.bo[bufnr].filetype] then
      return nil
    end
    return {
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    markdown = { 'prettier', stop_after_first = true },
  },
})

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer' })

local lint = require('lint')
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
}

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('caye_lint', { clear = true }),
  callback = function()
    if vim.opt_local.modifiable:get() then
      lint.try_lint()
    end
  end,
})

require('nvim-autopairs').setup({})
