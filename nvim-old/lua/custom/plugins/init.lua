-- C/CMake Editor configuration
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cmake" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Jump to last position on file open
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Jump to last position on file open",
  group = vim.api.nvim_create_augroup("custom-editor-open", { clear = true }),
  pattern = "*",
  callback = function(ev)
    if vim.fn.line "'\"" > 1 and vim.fn.line "'\"" <= vim.fn.line "$" then
      -- except for in git commit messages
      -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
      if not vim.fn.expand("%:p"):find(".git", 1, true) then
        vim.cmd 'exe "normal! g\'\\""'
      end
    end
  end,
})

return {}
