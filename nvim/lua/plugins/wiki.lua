return {
  "vimwiki/vimwiki",
  init = function()
    vim.g.vimwiki_list = {
      { path = "~/Notes/", syntax = "markdown", ext = "md" },
    }
  end,
  config = false,
}
