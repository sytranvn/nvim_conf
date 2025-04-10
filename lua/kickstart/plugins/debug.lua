-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
    'nvim-neotest/nvim-nio'
    -- JS debugger
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local mason_path = require('mason-core.path')

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {
        function(config)
          -- Keep original functionality
          require('mason-nvim-dap').default_setup(config)
        end,
        python = function(config)
          config.adapters = {
            type = 'executable',
            command = '/usr/bin/python3',
            args = { '-m', 'debugpy.adapter' }
          }
        end
      },

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'debugpy',
        'codelldb',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<F1>', dap.step_into)
    vim.keymap.set('n', '<F2>', dap.step_over)
    vim.keymap.set('n', '<F3>', dap.step_out)
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end)

    vim.api.nvim_create_user_command('DapClose', dapui.close, {})
    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      mappings = {

      },
      element_mappings = {
      },
      expand_lines = true,
      floating = {
        mappings = {
          close = "q"
        },
        border = "",
      },
      force_buffers = true,
      layouts = {
        {
          elements = {
            { id = "console", size = 0.25 },
            { id = "scopes",  size = 0.50 },
            { id = "repl",    size = 0.25 },
          },
          position = "left",
          size = 50,
        },
        {
          elements = {
            { id = "stacks",      size = 0.65 },
            { id = "watches",     size = 0.15 },
            { id = "breakpoints", size = 0.20 },
          },
          position = "bottom",
          size = 15,
        },
      },
      render = {
        indent = 2
      },
      controls = {
        enabled = true,
        element = "scopes",
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '▶',
          terminate = '⏹',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    -- keep dapui open to see any result, run :DapClose to close instead
    -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    -- dap.listeners.before.event_exited['dapui_config'] = dapui.close


    dap.adapters.codelldb = {
      type = 'server',
      port = "${port}",
      executable = {
        command = mason_path.package_prefix('codelldb') .. '/codelldb',
        args = { "--port", "${port}" },
      }
    }

    -- Install golang specific config
    require('dap-go').setup()
    require('debug.python')
    require('debug.codelldb')
    require('nvim-dap-virtual-text').setup({})
  end,
}
