return { {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
  },
  build = "make tiktoken",        -- Only on MacOS or Linux
  opts = {
    debug = false,                -- Enable debugging
    -- See Configuration section for rest
  },
  -- See Commands section for default commands if you want to lazy load on them
  keys = {
    {
      "<leader>cc",
      "<cmd>CopilotChat<cr>",
      desc = "CopilotChat - Open chat",
      -- mode = "n", -- normal mode
    },
  },
},
  {
    "zbirenbaum/copilot-cmp",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  -- {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   -- Registers copilot-chat filetype for markdown rendering
  --   opts = {
  --     file_types = { 'copilot-chat' }, -- only use for copilot window
  --   }
  --
  --   -- You might also want to disable default header highlighting for copilot chat when doing this and set error header style and separator
  --   -- require('CopilotChat').setup({
  --   --   highlight_headers = false,
  --   --   separator = '---',
  --   --   error_header = '> [!ERROR] Error',
  --   --   -- rest of your config
  --   -- })
  -- },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        ["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
        ["*.lua"] = true,
      },
    }
  }
}
