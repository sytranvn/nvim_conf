return {
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
