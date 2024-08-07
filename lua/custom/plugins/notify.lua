-- lazy.nvim
return {
  "rcarriga/nvim-notify",
  -- event = "VeryLazy",
  dependencies = {
  },
  config = function()
    local opts = {
      -- add any options here
    }
    local notify = require('notify')
    vim.notify = notify
    notify.setup(opts)
  end
}
