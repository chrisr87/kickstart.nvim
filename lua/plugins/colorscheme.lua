local function transparent_background()
  local groups = {
    'Normal',
    'NormalNC',
    'NormalFloat',
    'FloatBorder',
    'FloatTitle',
    'SignColumn',
    'LineNr',
    'CursorLineNr',
    'EndOfBuffer',
    'StatusLine',
    'StatusLineNC',
    'WinSeparator',
    'TelescopeNormal',
    'TelescopeBorder',
    'TelescopePromptNormal',
    'TelescopePromptBorder',
    'TelescopeResultsNormal',
    'TelescopeResultsBorder',
    'TelescopePreviewNormal',
    'TelescopePreviewBorder',
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
  end
end

return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        transparent = true,
        styles = {
          comments = { italic = false },
          sidebars = 'transparent',
          floats = 'transparent',
        },
      }

      vim.cmd.colorscheme 'tokyonight-night'
      transparent_background()

      vim.api.nvim_create_autocmd('ColorScheme', {
        desc = 'Keep transparent background after colorscheme changes',
        group = vim.api.nvim_create_augroup('user-transparent-background', { clear = true }),
        callback = transparent_background,
      })
    end,
  },
}
