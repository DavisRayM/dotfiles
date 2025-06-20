local set = vim.opt_local

set.shiftwidth = 2

vim.keymap.set("n", "<Leader>rt", "<cmd>PlenaryBustedFile %<CR>", { desc = "[R]un Current File [T]ests (Plenary)" })
