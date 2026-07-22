local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ''
  end

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return table.concat(names, ', ')
end

require('lualine').setup({
  options = {
    theme = 'ayu',
    icons_enabled = true,
    globalstatus = false,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = {
      'diff',
      {
        'filename',
        path = 0,
        symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]' },
      },
      'diagnostics',
    },
    lualine_x = { lsp_clients },
    lualine_y = { 'filetype' },
    lualine_z = { 'location', 'progress' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
})
