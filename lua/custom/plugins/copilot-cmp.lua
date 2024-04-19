return {
  "zbirenbaum/copilot-cmp",
  config = function()
    require("copilot_cmp").setup()
  end,
  enabled = function()
    return vim.g.CopilotEnabled
  end
}
