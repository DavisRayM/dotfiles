require('telescope').setup {
  defaults = {
    path_display = { "shorten" },
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "python", "json", "toml", "yaml" },
  sync_install = false,
  auto_install = true,
}

require('nvim-tree').setup {
  filters = {
    dotfiles = false,
  },
  view = {
    side = "left",
  },
}

require('lualine').setup {
  options = {
    theme = 'nord'
  }
}

--- Configure nord theme
vim.g.nord_contrast = true
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = false

-- Load the colorscheme
require('nord').set()

vim.opt.termguicolors = true
