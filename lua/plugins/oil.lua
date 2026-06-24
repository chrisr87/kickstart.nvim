return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    keys = {
      { '-', '<cmd>Oil --float<cr>', desc = 'Open parent directory' },
      { '<leader>e', '<cmd>Oil --float<cr>', desc = 'Open file explorer' },
    },
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = false,
      keymaps = {
        ['q'] = 'actions.close',
        ['<Esc>'] = 'actions.close',
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 2,
        max_width = 96,
        max_height = 32,
        border = 'rounded',
      },
    },
  },
}
