local state = { terminals = {}, current = -1, menu = { buf = -1, win = -1 } }
local fmt_active = "=> "

local function create_window(opts)
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
      style = opts.style or "minimal",
      border = opts.border or "rounded",
    })
  else
    vim.cmd "split"
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_height(win, opts.height or 10)
    vim.api.nvim_win_set_buf(win, buf)
  end

  return { buf = buf, win = win }
end

local create_terminal = function(opts)
  opts = opts or { floating = false, buf = -1, win = -1 }

  local term = create_window(opts)
  table.insert(state.terminals, term)

  state.current = table.maxn(state.terminals)

  if vim.bo[term.buf].buftype ~= "terminal" then
    vim.cmd.term()
  end

  vim.cmd "startinsert"
end

local toggle_terminal = function(opts)
  opts = opts or { floating = false, buf = -1, win = -1 }
  if state.current > 0 then
    local current = state.terminals[state.current]

    if not vim.api.nvim_win_is_valid(current.win) then
      state.terminals[state.current] = create_window { buf = current.buf, floating = opts.floating }
    else
      vim.api.nvim_win_hide(current.win)
    end
  else
    create_terminal(opts)
  end
end

local sync_terminals = function(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local original = vim.deepcopy(state.terminals, true)
  local removed = 0

  state.terminals = {}

  for _, line in ipairs(lines) do
    if line ~= "" then
      local active, idx, _ = string.match(line, "^(=>?)%s*(%d+):%s*(.+)$")

      if active == nil then
        idx, _ = string.match(line, "^%s*(%d+):%s*(.+)$")
      end

      if idx ~= nil then
        idx = tonumber(idx)
        table.insert(state.terminals, original[idx])
        if active ~= nil then
          state.current = table.maxn(state.terminals)
        end
        vim.schedule(function()
          table.remove(original, idx - removed)
          removed = removed + 1
        end)
      end
    end
  end

  vim.schedule(function()
    for _, term in ipairs(original) do
      if vim.api.nvim_buf_is_valid(term.buf) then
        vim.api.nvim_buf_delete(term.buf, { force = true })
      end
    end
  end)
end

local show_terminals = function()
  if vim.api.nvim_win_is_valid(state.menu.win) then
    vim.api.nvim_win_hide(state.menu.win)
  else
    state.menu = create_window {
      floating = true,
      buf = state.menu.buf,
      win = state.menu.win,
      width = math.floor(vim.o.columns * 0.4),
      height = math.floor(vim.o.lines * 0.5),
      border = "single",
    }
    local buf = state.menu.buf

    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
    vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
    vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
    vim.api.nvim_set_option_value("buftype", "", { buf = buf })
    vim.api.nvim_buf_set_name(buf, "Terminal List")

    local lines = {}
    for idx, inst in ipairs(state.terminals) do
      if vim.api.nvim_buf_is_valid(inst.buf) then
        table.insert(lines, string.format("%d: %s", idx, vim.api.nvim_buf_get_name(inst.buf)))
        if idx == state.current then
          lines[idx] = fmt_active .. lines[idx]
        end
      else
        table.remove(state.terminals, idx)
      end
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    vim.api.nvim_create_autocmd("BufWinLeave", {
      buffer = buf,
      callback = function()
        vim.api.nvim_win_close(state.menu.win, true)

        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end)
      end,
    })

    vim.api.nvim_create_autocmd("BufWriteCmd", {
      buffer = buf,
      callback = function()
        sync_terminals(buf)
      end,
    })
  end
end

vim.keymap.set({ "n", "t" }, "<leader>tc", create_terminal, { desc = "[C]reate terminal" })

vim.keymap.set({ "n", "t" }, "<leader>ts", show_terminals, { desc = "[S]how terminal list" })

vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_terminal, { desc = "[T]oggle terminal" })

vim.keymap.set({ "n", "t" }, "<leader>tf", function()
  toggle_terminal { floating = true, buf = -1, win = -1 }
end, { desc = "[T]oggle [f]loating terminal" })

return {}
