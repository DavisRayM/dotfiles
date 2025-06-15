vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Setup terminal window",
  group = vim.api.nvim_create_augroup("terminal-open", { clear = true }),
  callback = function()
    vim.o.number = false
    vim.o.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Jump to last position on file open",
  group = vim.api.nvim_create_augroup("editor-open", { clear = true }),
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
