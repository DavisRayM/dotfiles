local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}

  -- Create/Reuse buffer
  local buf
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win
  if opts.floating then
    -- Get the editor's total dimensions
    local columns = vim.o.columns
    local lines = vim.o.lines

    -- Default dimensions: 80% of the screen
    local width = opts.width or math.floor(columns * 0.8)
    local height = opts.height or math.floor(lines * 0.8)

    -- Center the window
    local row = math.floor((lines - height) / 2 - 1)
    local col = math.floor((columns - width) / 2)

    -- Create the floating window
    win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
    })
  else
    vim.cmd "split"
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_height(win, opts.height or 10)
    vim.api.nvim_win_set_buf(win, buf)
  end

  return { buf = buf, win = win }
end

local toggle_terminal = function(opts)
  opts = opts or { floating = false }

  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf, floating = opts.floating }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.term()
    end
    vim.cmd "startinsert"
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_terminal, { desc = "[T]oggle terminal" })
vim.keymap.set({ "n", "t" }, "<leader>tf", function()
  toggle_terminal { floating = true }
end, { desc = "[T]oggle [f]loating terminal" })

return {}
