local config_dir = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
vim.opt.runtimepath:prepend(config_dir)

local registered_command
local mason_setup_called = false
local executed_commands = {}

local original_create_user_command = vim.api.nvim_create_user_command
local original_cmd = vim.cmd

vim.api.nvim_create_user_command = function(name, callback, options)
  registered_command = { name = name, callback = callback, options = options }
end

vim.cmd = function(command)
  table.insert(executed_commands, command)
end

package.loaded['config.mason'] = nil
package.loaded['mason'] = nil
package.preload['mason'] = function()
  return {
    setup = function(options)
      mason_setup_called = true
    end,
  }
end

local ok, err = pcall(require, 'config.mason')

assert(ok, err)
assert(mason_setup_called, 'config.mason must configure Mason')
assert(registered_command.name == 'LspInstall', 'must register :LspInstall')
assert(registered_command.options.nargs == '*', ':LspInstall accepts zero or more servers')

registered_command.callback({ fargs = { 'lua_ls', 'ts_ls' } })
assert(
  executed_commands[1] == 'MasonInstall lua-language-server typescript-language-server',
  ':LspInstall must translate LSP names to Mason package names'
)

local invalid_ok = pcall(registered_command.callback, { fargs = { 'unknown_server' } })
assert(not invalid_ok, ':LspInstall must reject unknown servers')

vim.api.nvim_create_user_command = original_create_user_command
vim.cmd = original_cmd
package.preload['mason'] = nil
package.loaded['mason'] = nil
package.loaded['config.mason'] = nil
