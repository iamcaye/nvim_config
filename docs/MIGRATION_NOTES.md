# Migration Notes From Previous Kickstart Config

## Kept

- Leader on space.
- Core editor options.
- Telescope search mappings, with the `<leader>sg` conflict fixed.
- Oil project view on `<leader>pv`.
- Harpoon mappings.
- Gitsigns hunk mappings.
- Snacks UI helpers.
- Copilot and Sidekick toggles.
- Formatting with Conform.
- Linting with nvim-lint.
- DAP basics.
- Ayu colorscheme.

## Changed For Neovim 0.12

- Plugin management now uses native `vim.pack`.
- LSP uses `vim.lsp.config()` and `vim.lsp.enable()`.
- Completion uses native `vim.lsp.completion.enable()`.
- Diagnostic navigation uses `vim.diagnostic.jump()`.
- Autocommands use `nvim_create_autocmd()`.
- No Neovim 0.10 compatibility branches.

## Removed

- `lazy.nvim`.
- `nvim-cmp` and LuaSnip from the initial version.
- Mason automation from the initial version.
- The local `caye-ember.lua` colorscheme.
- Commented plugin modules carried over from Kickstart.
