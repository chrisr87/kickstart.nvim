vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.swapfile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.termguicolors = true

vim.opt.fillchars:append { eob = ' ' }

local mouse_modes = { 'n', 'i', 'v', 'x', 's', 'o', 'c', 't' }
local mouse_keys = {
  '<MiddleMouse>',
  '<MiddleDrag>',
  '<MiddleRelease>',
  '<2-MiddleMouse>',
  '<2-MiddleDrag>',
  '<2-MiddleRelease>',
  '<3-MiddleMouse>',
  '<3-MiddleDrag>',
  '<3-MiddleRelease>',
  '<4-MiddleMouse>',
  '<4-MiddleDrag>',
  '<4-MiddleRelease>',
}

for _, mode in ipairs(mouse_modes) do
  for _, key in ipairs(mouse_keys) do
    vim.keymap.set(mode, key, '<Nop>', { noremap = true, silent = true })
  end
end
