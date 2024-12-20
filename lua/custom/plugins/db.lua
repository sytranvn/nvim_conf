return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup( --[[optional config]])
    vim.api.nvim_create_user_command("Dbee", function()
      local dbee = require("dbee")
      if not dbee.is_open() then
        vim.api.nvim_command("tabnew")
        dbee.open()
      else
        dbee.close()
      end
    end, {})
  end,
}
