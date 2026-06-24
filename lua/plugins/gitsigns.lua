return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map('n', '<leader>hp', gitsigns.preview_hunk, 'Preview git hunk')
        map('n', '<leader>hr', gitsigns.reset_hunk, 'Reset git hunk')
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Reset selected git hunk')
        map('n', '<leader>hs', gitsigns.stage_hunk, 'Stage git hunk')
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Stage selected git hunk')
        map('n', '<leader>hb', gitsigns.blame_line, 'Blame line')
      end,
    },
  },
}
