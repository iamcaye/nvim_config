local server_packages = {
  eslint = 'vscode-eslint-language-server',
  lua_ls = 'lua-language-server',
  ts_ls = 'typescript-language-server',
}

require('mason').setup()

local function install_servers(server_names)
  if #server_names == 0 then
    server_names = vim.tbl_keys(server_packages)
    table.sort(server_names)
  end

  local packages = {}
  for _, server_name in ipairs(server_names) do
    local package_name = server_packages[server_name]
    if not package_name then
      error(('Unknown LSP server: %s'):format(server_name))
    end
    table.insert(packages, package_name)
  end

  vim.cmd('MasonInstall ' .. table.concat(packages, ' '))
end

vim.api.nvim_create_user_command('LspInstall', function(command)
  install_servers(command.fargs)
end, {
  nargs = '*',
  complete = function()
    return vim.tbl_keys(server_packages)
  end,
  desc = 'Install configured language servers with Mason',
})
