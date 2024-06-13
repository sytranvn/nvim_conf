-- taken from this PR https://github.com/nvim-lualine/lualine.nvim/pull/1251

local M = {}

M.filetypes = {
  "dap-repl",
  "dapui_console",
  "dapui_console",
  "dapui_watches",
  "dapui_stacks",
  "dapui_breakpoints",
  "dapui_scopes",
}

local function merge_colors(foreground, background)
  local new_name = foreground .. background

  local hl_fg = vim.api.nvim_get_hl(0, { name = foreground })
  local hl_bg = vim.api.nvim_get_hl(0, { name = background })

  local fg = string.format("#%06x", hl_fg.fg and hl_fg.fg or 0)
  local bg = string.format("#%06x", hl_bg.bg and hl_bg.bg or 0)

  vim.api.nvim_set_hl(0, new_name, { fg = fg, bg = bg })
  return new_name
end

local function get_dap_repl_winbar(active)
  -- local get_mode = require("lualine.highlight").get_mode_suffix

  return function()
    local filetype = vim.bo.filetype
    local disabled_filetypes = { "dap-repl" }

    if not vim.tbl_contains(disabled_filetypes, filetype) then
      return ""
    end
    -- active and get_mode() or
    local background_color = string.format("lualine_b" .. "%s", "_inactive")

    local controls_string = "%#" .. background_color .. "#"
    for element in require("dapui.controls").controls():gmatch("%S+") do
      local color, action = string.match(element, "%%#(.*)#(%%.*)%%#0#")
      controls_string = controls_string .. " %#" .. merge_colors(color, background_color) .. "#" .. action
    end
    return controls_string
  end
end

M.winbar = {
  lualine_a = { { "filename", file_status = false } },
  lualine_b = { get_dap_repl_winbar(true) },
}

M.inactive_winbar = {
  lualine_a = { { "filename", file_status = false } },
  lualine_b = { get_dap_repl_winbar(false) },
}



return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  dependencies = {
    "loctvl842/breadcrumb.nvim"
  },
  -- See `:help lualine.txt`
  config = function()
    local breadcrumb = function()
      if vim.fn.wordcount().bytes > 200000 then
        return "󰔟"
      end
      local breadcrumb_status_ok, breadcrumb = pcall(require, "breadcrumb")
      require("breadcrumb")
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
      },
      extensions = { M }
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
