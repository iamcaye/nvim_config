# nvim_config

Configuracion nueva para Neovim 0.12.

## Objetivos

- Usar APIs modernas de Neovim 0.12.
- Evitar `require('lspconfig').setup`, `vim.diagnostic.goto_next` y ramas de
  compatibilidad antiguas.
- Usar `vim.pack` como gestor nativo de plugins.
- Mantener una estructura modular y facil de auditar.
- Usar `ayu` como tema unico.

## Instalacion

Puedes probarla sin reemplazar tu configuracion actual:

```sh
NVIM_APPNAME=nvim_config nvim
```

Si quieres usar esta carpeta directamente como config, colocala en:

```text
~/.config/nvim_config
```

Neovim instalara los plugins declarados en `lua/config/pack.lua` en el primer
arranque. Para actualizar plugins:

```vim
:packupdate
```

## Requisitos externos

- Neovim 0.12 o superior.
- `git`.
- `rg` para busquedas con Telescope.
- Servidores LSP en el PATH:
  - `lua-language-server` para `lua_ls`.
  - `vscode-eslint-language-server` para `eslint`.
- Formateadores opcionales:
  - `stylua`, `prettier`, `prettierd`.
- Linters opcionales:
  - `markdownlint`.
- Debug Go opcional:
  - `dlv`.

## Estructura

```text
init.lua
lua/config/
lua/plugins/
docs/
```

## Notas

Esta config no incluye `caye-ember.lua`; el tema activo es `ayu`.
