return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    delay = 0,
    spec = {
      { "<leader>s", group = "[S]earch" },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>w", group = "[W]iki" },
      { "<leader>g", group = "[G]it" },
      { "<leader>r", group = "[R]un" },
      { "g",         group = "[G]lobal" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "View all Keymaps",
    },
  },
}
