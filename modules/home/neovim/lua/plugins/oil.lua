return {
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup {
      columns = {
        "icon",
      },
      constrain_cursor = "editable",
      watch_for_changes = true,
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          local m = name:match "^.git$"
          return m ~= nil
        end,
      },
    }

    vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open File Explorer" })
  end,
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  lazy = false,
}
