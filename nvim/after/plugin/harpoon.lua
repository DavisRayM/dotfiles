local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>ma", mark.add_file, { desc = "Add new mark" })
vim.keymap.set("n", "<leader>mm", ui.toggle_quick_menu, { desc = "Toggle quick menu for marks" })
