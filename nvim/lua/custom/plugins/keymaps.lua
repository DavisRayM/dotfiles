-- Quickfix fast navigation
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Goto next quickfix list line" })
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Goto previous quickfix list line" })

-- Lua QOL
vim.keymap.set("v", "<space>x", ":lua<CR>", { desc = "Evaluate visually selected text (LUA)" })
vim.keymap.set("n", "<space>x", ":.lua<CR>", { desc = "Evaluate line at cursor (LUA)" })

-- Quick text shifting
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Shift selected text downwards" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Shift selected text upwards" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Move line below to the right of current line" })

-- Center search results
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "*", "*zz", { silent = true })
vim.keymap.set("n", "#", "#zz", { silent = true })
vim.keymap.set("n", "g*", "g*zz", { silent = true })

-- Quickly Switch to Netrw
-- vim.keymap.set("n", "<Leader>pe", vim.cmd.Ex, { desc = "Open [P]roject & [E]xplore in netrw" })

return {}
