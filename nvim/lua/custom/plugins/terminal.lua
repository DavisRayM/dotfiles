local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function OpenFloatingWindow(opts)
	opts = opts or {}

	-- Get the editor's total dimensions
	local columns = vim.o.columns
	local lines = vim.o.lines

	-- Default dimensions: 80% of the screen
	local width = opts.width or math.floor(columns * 0.8)
	local height = opts.height or math.floor(lines * 0.8)

	-- Center the window
	local row = math.floor((lines - height) / 2 - 1)
	local col = math.floor((columns - width) / 2)

	-- Create a new scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
	})

	return { buf = buf, win = win }
end

return {}
