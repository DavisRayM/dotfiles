return {
  "DavisRayM/term-manager.nvim",
  config = function()
    local manager = require("term-manager")

    vim.keymap.set("n", "<leader>tt", manager.toggle_terminal, { desc = "[T]oggle [T]erminal" })
  end
}
