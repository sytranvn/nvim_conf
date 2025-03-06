return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
  },
  build = "make tiktoken", -- Only on MacOS or Linux
  opts = {
    debug = false, -- Enable debugging
    -- See Configuration section for rest
  },
  -- Add key mapping
  keys = {
    {
      "<leader>cc",
      "<cmd>CopilotChat<cr>",
      desc = "CopilotChat - Open chat",
      -- mode = "n", -- normal mode
    },
  },
  -- See Commands section for default commands if you want to lazy load on them
}
