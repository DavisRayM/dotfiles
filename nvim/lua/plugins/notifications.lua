return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")

    notify.setup {
      render = "compact",
      stages = "fade",
      merge_duplicates = true,
    }
    vim.notify = notify
  end,
  priority = 100,
}
