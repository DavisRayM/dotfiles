-- [[ Options ]]
-- `See :help option-list`
local set = vim.opt

set.breakindent = true
set.confirm = true
set.cursorline = true
set.expandtab = true
set.ignorecase = true
set.inccommand = "split"
set.list = true
set.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
set.number = true
set.relativenumber = true
set.scrolloff = 999
set.shiftwidth = 4
set.showmode = false
set.signcolumn = "yes"
set.smartcase = true
set.softtabstop = -1
set.swapfile = false
set.termguicolors = true
set.timeoutlen = 500
set.title = true
set.titlestring = "[NVIM] %t"
set.undofile = true

vim.schedule(function()
  set.clipboard = "unnamedplus"
end)
