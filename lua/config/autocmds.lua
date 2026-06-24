vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Use two-space indentation for web/config formats',
  group = vim.api.nvim_create_augroup('user-filetype-indent', { clear = true }),
  pattern = {
    'css',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'lua',
    'markdown',
    'typescript',
    'typescriptreact',
    'yaml',
  },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})
