--  See `:help vim.pack`, `:help vim.pack-examples` or the
--  excellent blog post from the creator of vim.pack and mini.nvim:
--  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
--
--  To inspect plugin state and pending updates, run
--    :lua vim.pack.update(nil, { offline = true })
--
--  To update plugins, run
--    :lua vim.pack.update()
local function gh(repo)
	return "https://github.com/" .. repo
end

-- Guess indentations
vim.pack.add({ gh("NMAC427/guess-indent.nvim") })
require("guess-indent").setup({})

-- Oil
vim.pack.add({ gh("stevearc/oil.nvim") })
require("oil").setup({
	default_file_explorer = true,
	colums = {
		"icon",
		"permissions",
	},
})

-- Nerd Icons
vim.pack.add({ gh("nvim-tree/nvim-web-devicons") })

-- What are my keybinds ?
vim.pack.add({ gh("folke/which-key.nvim") })
require("which-key").setup({
	delay = 0,
	icons = { mappings = true },
	spec = {
		{ "<leader>o", group = "[O]pen", mode = { "n", "v" } },
		{ "<leader>t", group = "[T]oggle" },
		{ "<leader>b", group = "[B]uffer" },
		{ "<leader>f", group = "[F]ile" },
		{ "<leader>s", group = "[S]earch" },
		{ "<leader>c", group = "[C]ode" },
		{ "<leader>g", group = "[G]it" },
		{ "<leader>w", group = "[W]indow" },
		{ "gr", group = "LSP Actions", mode = { "n" } },
	},
})

-- Highlighted TODOs
vim.pack.add({ gh("folke/todo-comments.nvim") })
require("todo-comments").setup({ signs = false })

-- Fuzzy finder
vim.pack.add({ gh("ibhagwan/fzf-lua") })
require("fzf-lua").setup({})

-- Mini
vim.pack.add({ gh("nvim-mini/mini.nvim") })
require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})
require("mini.icons").setup({})
require("mini.diff").setup({
	view = {
		style = "sign",
	},
})
require("mini.git").setup({})

-- Treesitter
vim.pack.add({ { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" } })
local parsers = {
	"bash",
	"c",
	"diff",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
	"rust",
	"cpp",
	"nix",
	"go",
}
require("nvim-treesitter").install(parsers)

-- LSP Status
vim.pack.add({ gh("j-hui/fidget.nvim") })
require("fidget").setup({})

-- Mason
local servers = {
	rust_analyzer = {},
	clangd = {},
	gopls = {},
	ty = {},
	stylua = {},
	lua_ls = {
		on_init = function(client)
			client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					version = "LuaJIT",
					path = { "lua/?.lua", "lua/?/init.lua" },
				},
				workspace = {
					checkThirdParty = false,
					-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
					--  See https://github.com/neovim/nvim-lspconfig/issues/3189
					library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
						"${3rd}/luv/library",
						"${3rd}/busted/library",
					}),
				},
			})
		end,
		---@type lspconfig.settings.lua_ls
		settings = {
			Lua = {
				format = { enable = false }, -- Disable formatting (formatting is done by stylua)
			},
		},
	},
}

vim.pack.add({
	gh("neovim/nvim-lspconfig"),
	gh("mason-org/mason.nvim"),
	gh("mason-org/mason-lspconfig.nvim"),
	gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
})
require("mason").setup({})

local ensure_installed = vim.tbl_keys(servers or {})
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end

-- Formatting
vim.pack.add({ gh("stevearc/conform.nvim") })
require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- You can specify filetypes to autoformat on save here:
		local enabled_filetypes = {
			-- lua = true,
			-- python = true,
		}
		if enabled_filetypes[vim.bo[bufnr].filetype] then
			return { timeout_ms = 500 }
		else
			return nil
		end
	end,
	default_format_opts = {
		lsp_format = "fallback", -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
	},
	-- You can also specify external formatters in here.
	formatters_by_ft = {
		-- rust = { 'rustfmt' },
		-- Conform can also run multiple formatters sequentially
		-- python = { "isort", "black" },
		--
		-- You can use 'stop_after_first' to run the first available formatter from the list
		-- javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

-- Completion
vim.pack.add({ { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") } })
require("blink.cmp").setup({
	keymap = {
		-- 'default' (recommended) for mappings similar to built-in completions
		--   <c-y> to accept ([y]es) the completion.
		--    This will auto-import if your LSP supports it.
		--    This will expand snippets if the LSP sent a snippet.
		-- 'super-tab' for tab to accept
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- For an understanding of why the 'default' preset is recommended,
		-- you will need to read `:help ins-completion`
		--
		-- No, but seriously. Please read `:help ins-completion`, it is really good!
		--
		-- All presets have the following mappings:
		-- <tab>/<s-tab>: move to right/left of your snippet expansion
		-- <c-space>: Open menu or open docs if already open
		-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
		-- <c-e>: Hide menu
		-- <c-k>: Toggle signature help
		--
		-- See `:help blink-cmp-config-keymap` for defining your own keymap
		preset = "default",
	},

	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		-- By default, you may press `<c-space>` to show the documentation.
		-- Optionally, set `auto_show = true` to show the documentation after a delay.
		documentation = { auto_show = false, auto_show_delay_ms = 500 },
	},
	sources = {
		default = { "lsp", "path", "snippets" },
	},
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
})
