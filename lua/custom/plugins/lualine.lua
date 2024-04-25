return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  dependencies = {
    "loctvl842/breadcrumb.nvim"
  },
  -- See `:help lualine.txt`
  config = function()
    local breadcrumb = function()
      local breadcrumb_status_ok, breadcrumb = pcall(require, "breadcrumb")
      if not breadcrumb_status_ok then
        return
      end
      return breadcrumb.get_breadcrumb()
    end

    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_y = {
          'progress',
          'location'
        },
      },
      winbar = {
        lualine_a = { { 'filename', path = 1 } },
        lualine_c = { breadcrumb }
      },
      inactive_winbar = {
        lualine_a = { { 'filename', path = 1 } },
        lualine_c = { breadcrumb }
      }
    })
    vim.api.nvim_create_user_command("BuffCloseOthers", function()
      local bufs = vim.api.nvim_list_bufs()
      for b in bufs do
        b:close()
      end
    end, {})

    vim.api.nvim_create_user_command("BuffCloseAll", ":bufdo bd", {})
    vim.keymap.set('n', 'gn', ':bn<CR>', { silent = true })
    vim.keymap.set('n', 'gN', ':bp<CR>', { silent = true })
  end
}
