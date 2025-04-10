local M = {}

local breadcrumb = require("breadcrumb")

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {},
  -- gopls = {},
  pyright = {
    python = {
      analysis = {
        typeCheckingMode = 'strict',
        languageServerMode = 'light',
      },
    },
  },
  pylsp = {
    configurationSources = { 'pycodestyle' },
    plugins = {
      black = {
        enabled = false,
        cache_config = false,
      },
      flake8 = {
        enabled = false
      },
      pyflakes = { enabled = false },
      pylint = { enabled = false },
      pycodestyle = { enabled = false },
      ruff = {
        enabled = true,                      -- Enable the plugin
        formatEnabled = true,                -- Enable formatting using ruffs formatter
        extendIgnore = { "C90" },            -- Rules that are additionally ignored by ruff
        format = { "I" },                    -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
        -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
        lineLength = 88,                               -- Line length to pass to ruff checking and formatting
      },
    }
  },
  -- rust_analyzer = {},
  ts_ls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  jsonls = {

  },
}

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  if client.server_capabilities.documentSymbolProvider then
    breadcrumb.attach(client, bufnr)
  end

  if client.name == "pyright" then
    client.server_capabilities.documentFormattingProvider = false
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- LSP settings.
M.setup = function()
  -- Setup neovim lua configuration
  require('neodev').setup()

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = 'rounded',
    }
  )

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = 'rounded',
    }
  )
  -- Setup mason so it can manage external tooling
  require('mason').setup()

  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  mason_lspconfig.setup_handlers {
    function(server_name)
      if vim.g.project_lsps and vim.g.project_lsps[server_name] then
        servers[server_name] = vim.tbl_deep_extend("force", servers[server_name], vim.g.project_lsps[server_name])
      end
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      }
    end,
  }
end

return M
