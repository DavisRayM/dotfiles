return {
  "tris203/precognition.nvim",
  event = "VeryLazy",
  config = function()
    require "precognition".setup {
      startVisible = false,
      showBlankVirtLine = false,
    }

    vim.keymap.set("n", "<leader>tp", function()
      require("precognition").toggle()
    end, { desc = "[T]oggle [P]recognition" })
  end,
}
