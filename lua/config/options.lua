vim.g.have_nerd_font = true

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.showmode = false
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.inccommand = 'split'
opt.cursorline = true
opt.scrolloff = 10
opt.confirm = true
opt.termguicolors = true
opt.colorcolumn = '80,120'
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = true
opt.completeopt = { 'menu', 'menuone', 'popup', 'noinsert', 'nearest' }
opt.pumheight = 12

if vim.fn.has('nvim-0.12') == 1 then
  opt.autocomplete = true
end
