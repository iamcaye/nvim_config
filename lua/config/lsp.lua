vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('caye_lsp_attach', { clear = true }),
  desc = 'Configure LSP keymaps and capabilities for attached buffers',
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufnr = event.buf

    local map = function(keys, rhs, desc, mode)
      vim.keymap.set(mode or 'n', keys, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end

    map('gd', vim.lsp.buf.definition, 'Goto definition')
    map('gr', vim.lsp.buf.references, 'Goto references')
    map('gI', vim.lsp.buf.implementation, 'Goto implementation')
    map('gD', vim.lsp.buf.declaration, 'Goto declaration')
    map('<leader>D', vim.lsp.buf.type_definition, 'Type definition')
    map('<leader>rn', vim.lsp.buf.rename, 'Rename')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
    map('<leader>ds', function()
      require('telescope.builtin').lsp_document_symbols()
    end, 'Document symbols')
    map('<leader>ws', function()
      require('telescope.builtin').lsp_dynamic_workspace_symbols()
    end, 'Workspace symbols')

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
      map('<leader>uh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, 'Toggle inlay hints')
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
      local group = vim.api.nvim_create_augroup('caye_lsp_highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('caye_lsp_detach', { clear = true }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        end,
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, bufnr) then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
  end,
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = {
        globals = { 'vim', 'Snacks' },
      },
    },
  },
})

vim.lsp.config('eslint', {
  settings = {
    workingDirectories = { mode = 'auto' },
  },
})

for _, server in ipairs({ 'lua_ls', 'eslint' }) do
  vim.lsp.enable(server)
end
