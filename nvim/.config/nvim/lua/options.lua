-- See: help <option>
local opts = vim.opt
opts.number = true
opts.relativenumber = true
opts.cursorline = true
opts.wrap = false
opts.scrolloff = 10
opts.sidescrolloff = 10

opts.tabstop = 2
opts.shiftwidth = 2
opts.softtabstop = 2
opts.expandtab = true
opts.autoindent = true

opts.ignorecase = true
opts.smartcase = true
opts.hlsearch = true
opts.incsearch = true
opts.inccommand = "split"

opts.signcolumn = "yes"
opts.colorcolumn = "100"
opts.showmatch = true
opts.cmdheight = 1
opts.completeopt = "menuone,noinsert,noselect"
opts.showmode = false
opts.pumheight = 10
opts.pumblend = 10
opts.winblend = 0
opts.conceallevel = 0
opts.concealcursor = ""
opts.synmaxcol = 300
opts.fillchars = { eob = " " }

local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

opts.backup = false
opts.writebackup = false
opts.swapfile = false
opts.undofile = true
opts.undodir = undodir
opts.updatetime = 300
opts.timeoutlen = 500
opts.ttimeoutlen = 0
opts.autoread = true
opts.autowrite = false

opts.hidden = true
opts.errorbells = false
opts.backspace = "indent,eol,start"
opts.autochdir = false
opts.iskeyword:append("-")
opts.path:append("**")
opts.selection = "inclusive"
opts.clipboard:append("unnamedplus")
opts.modifiable = true
opts.encoding = "UTF-8"

opts.foldmethod = "expr"
opts.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opts.foldlevel = 99

opts.splitbelow = true
opts.splitright = true

opts.wildmenu = true
opts.wildmode = "longest:full,full"
opts.diffopt:append("linematch:60")
opts.redrawtime = 10000
opts.maxmempattern = 20000
