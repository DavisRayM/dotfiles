local binary_path = vim.fn.expand("~/.local/bin")

if not vim.env.PATH:find(binary_path, 1, true) then
  vim.env.PATH = vim.env.PATH .. ":" .. binary_path
end
