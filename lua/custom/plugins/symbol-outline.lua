return {
  'simrat39/symbols-outline.nvim',
  config = true, -- needed to trigger setup call
  keys = {
    {
      "<leader>o",
      "<cmd>SymbolsOutline<cr>",
      desc = "[S]ymbol [O]utline",
      mode = "n", -- normal mode
    },
  },
}
