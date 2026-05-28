vim.g.mapleader = " "
vim.g.maplocalleader = " "

local set = vim.keymap.set

set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlighting" })
set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

set("n", "<left>", "<cmd>echo 'Use h to move!!'<CR>")
set("n", "<right>", "<cmd>echo 'Use l to move!!'<CR>")
set("n", "<up>", "<cmd>echo 'Use k to move!!'<CR>")
set("n", "<down>", "<cmd>echo 'Use j to move!!'<CR>")

set("n", "<leader>wh", "<C-w><C-h>", { desc = "Move focus to the left window" })
set("n", "<leader>wl", "<C-w><C-l>", { desc = "Move focus to the right window" })
set("n", "<leader>wj", "<C-w><C-j>", { desc = "Move focus to the lower window" })
set("n", "<leader>wk", "<C-w><C-k>", { desc = "Move focus to the upper window" })
set("n", "<leader>wc", "<C-w><C-q>", { desc = "[C]lose window" })
set("n", "<leader>wv", "<C-w><C-v>", { desc = "Split window [V]ertically" })
set("n", "<leader>ws", "<C-w><C-s>", { desc = "Split window [H]orizontally" })

set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

set("v", "<", "<gv", { desc = "Indent left and reselect" })
set("v", ">", ">gv", { desc = "Indent right and reselect" })
set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "[T]oggle [D]iagnostics" })

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },
	virtual_text = true,
	virtual_lines = false,
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
	},
})

set("n", "<leader>oq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
set("n", "<leader>o-", ":Oil<CR>", { desc = "Open parent directory" })

set("n", "<leader>bn", ":bnext<CR>", { desc = "Go to [N]ext buffer" })
set("n", "<leader>bp", ":bprevious<CR>", { desc = "Go to [P]revious buffer" })
set("n", "<leader>bs", ":write<CR>", { desc = "[S]ave current buffer to file" })
set("n", "<leader>bb", function()
	require("fzf-lua").buffers()
end, { desc = "Search open [B]uffers" })

set("n", "<leader>sf", function()
	require("fzf-lua").live_grep()
end, { desc = "Search project files" })

set("n", "<leader><leader>", function()
	require("fzf-lua").files()
end, { desc = "Find project file" })

set("n", "<leader>fs", ":write<CR>", { desc = "[S]ave current buffer to file" })

set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true })
end, { desc = "[F]ormat buffer" })
set("n", "<leader>qq", ":wq<CR>", { desc = "[Q]uit and save buffer" })

set("n", "<leader>gd", function()
	require("mini.diff").toggle_overlay()
end, { desc = "Preview diff overlay" })
