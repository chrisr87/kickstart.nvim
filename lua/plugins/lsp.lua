return {

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate', 'MasonToolsClean' },
    opts = {
      ensure_installed = {
        'stylua',
        'shfmt',
        'shellcheck',
        'prettier',
        'eslint_d',
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local builtin = require 'telescope.builtin'

          map('grn', vim.lsp.buf.rename, 'rename')
          map('gra', vim.lsp.buf.code_action, 'code action', { 'n', 'x' })
          map('grr', builtin.lsp_references, 'references')
          map('gri', builtin.lsp_implementations, 'implementation')
          map('grd', builtin.lsp_definitions, 'definition')
          map('grD', vim.lsp.buf.declaration, 'declaration')
          map('gO', builtin.lsp_document_symbols, 'document symbols')
          map('gW', builtin.lsp_dynamic_workspace_symbols, 'workspace symbols')
          map('grt', builtin.lsp_type_definitions, 'type definition')
          map('K', vim.lsp.buf.hover, 'hover')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local group = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = false })

            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = group,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
              callback = function(detach_event)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = group, buffer = detach_event.buf }
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'toggle inlay hints')
          end
        end,
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        lua_ls = {
          cmd = { vim.fn.stdpath 'data' .. '/mason/bin/lua-language-server' },
          filetypes = { 'lua' },
          root_markers = {
            '.luarc.json',
            '.luarc.jsonc',
            '.luacheckrc',
            '.stylua.toml',
            'stylua.toml',
            'selene.toml',
            'selene.yml',
            '.git',
          },
          capabilities = capabilities,
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },

        rust_analyzer = {
          cmd = function(dispatchers, config)
            local wrapper = vim.fs.joinpath(config.root_dir, '.devcontainer', 'editor', 'rust-analyzer')

            if vim.fn.executable(wrapper) == 1 then
              return vim.lsp.rpc.start({ wrapper }, dispatchers)
            end

            if vim.fn.executable('rust-analyzer') == 1 then
              return vim.lsp.rpc.start({ 'rust-analyzer' }, dispatchers)
            end

            vim.notify('rust-analyzer not found: no project wrapper or host binary', vim.log.levels.WARN)
            return nil
          end,
          filetypes = { 'rust' },
          root_markers = {
            'Cargo.toml',
            'rust-project.json',
            '.git',
          },
          capabilities = capabilities,
          settings = {
            ['rust-analyzer'] = {
              cargo = { allFeatures = true },
              check = { command = 'clippy' },
            },
          },
        },

        bashls = {
          cmd = { vim.fn.stdpath 'data' .. '/mason/bin/bash-language-server', 'start' },
          filetypes = { 'sh', 'bash', 'zsh' },
          root_markers = {
            '.git',
          },
          capabilities = capabilities,
        },
        ts_ls = { capabilities = capabilities },
        eslint = { capabilities = capabilities },
        jsonls = { capabilities = capabilities },
        yamlls = { capabilities = capabilities },
        html = { capabilities = capabilities },
        cssls = { capabilities = capabilities },
        taplo = { capabilities = capabilities },
        marksman = { capabilities = capabilities },
        jdtls = { capabilities = capabilities },
      }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_enable = false,
      }

      for server_name, server_config in pairs(servers) do
        vim.lsp.config(server_name, server_config)
      end

      vim.lsp.enable(vim.tbl_keys(servers))

      vim.api.nvim_create_user_command('UserLspConfigs', function()
        print(vim.inspect(vim.tbl_keys(servers)))
      end, {})

      vim.api.nvim_create_user_command('UserLspClients', function()
        print(vim.inspect(vim.lsp.get_clients { bufnr = 0 }))
      end, {})

    end,
  },
}
