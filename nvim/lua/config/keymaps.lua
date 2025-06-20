local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlighting" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<left>", "<cmd>echo 'Use h to move!!'<CR>")
map("n", "<right>", "<cmd>echo 'Use l to move!!'<CR>")
map("n", "<up>", "<cmd>echo 'Use k to move!!'<CR>")
map("n", "<down>", "<cmd>echo 'Use j to move!!'<CR>")

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

map("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Move to next item in quickfix list" })
map("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Move to previous item in quickfix list" })

map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostic [Q]uickfix List" })

map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })
map("n", "*", "*zz", { silent = true })
map("n", "#", "#zz", { silent = true })
map("n", "g*", "g*zz", { silent = true })
