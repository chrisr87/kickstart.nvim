return {
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = { 'n', 'v' },
        desc = 'Format buffer',
      },
    },
    config = function()
      require('conform').setup {
        notify_on_error = false,

        format_on_save = function(bufnr)
          local disabled = {
            java = true,
          }

          if disabled[vim.bo[bufnr].filetype] then
            return nil
          end

          return {
            timeout_ms = 1000,
            lsp_format = 'fallback',
          }
        end,

        formatters = {
          rustfmt = {
            command = function(self, ctx)
              local root = vim.fs.root(ctx.buf, { 'Cargo.toml', 'rust-project.json', '.git' })
              if root then
                local wrapper = vim.fs.joinpath(root, '.devcontainer', 'editor', 'rustfmt')
                if vim.fn.executable(wrapper) == 1 then
                  return wrapper
                end
              end

              return 'rustfmt'
            end,
          },
        },

        formatters_by_ft = {
          lua = { 'stylua' },
          rust = { 'rustfmt' },
          sh = { 'shfmt' },
          bash = { 'shfmt' },

          javascript = { 'prettier', stop_after_first = true },
          javascriptreact = { 'prettier', stop_after_first = true },
          typescript = { 'prettier', stop_after_first = true },
          typescriptreact = { 'prettier', stop_after_first = true },
          json = { 'prettier', stop_after_first = true },
          jsonc = { 'prettier', stop_after_first = true },
          yaml = { 'prettier', stop_after_first = true },
          markdown = { 'prettier', stop_after_first = true },
          css = { 'prettier', stop_after_first = true },
          html = { 'prettier', stop_after_first = true },
        },
      }
    end,
  },
}
