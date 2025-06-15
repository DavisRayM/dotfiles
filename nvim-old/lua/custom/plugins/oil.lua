vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

return {
  "stevearc/oil.nvim",
  opts = {
    columns = {
      "icon",
      "permissions",
    },
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, bufnr)
        local m = name:match "^.git$"
        return m ~= nil
      end,
    },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  lazy = false,
}
