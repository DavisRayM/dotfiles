return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    local autopairs = require 'mini.pairs'
    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = true }
    autopairs.setup({})

    statusline.section_location = function()
      return '%2l|%-2v'
    end
  end,
}
