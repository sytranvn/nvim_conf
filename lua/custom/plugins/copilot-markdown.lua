return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- Registers copilot-chat filetype for markdown rendering
  opts = {
    file_types = { 'copilot-chat' }, -- only use for copilot window
  }

  -- You might also want to disable default header highlighting for copilot chat when doing this and set error header style and separator
  -- require('CopilotChat').setup({
  --   highlight_headers = false,
  --   separator = '---',
  --   error_header = '> [!ERROR] Error',
  --   -- rest of your config
  -- })
}
