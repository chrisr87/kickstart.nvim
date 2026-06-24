vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left split' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower split' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper split' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right split' })
