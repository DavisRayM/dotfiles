-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    vim.keymap.set('n', '<leader>cf', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
  end,
})

-- Mason: LSP Auto Install
require('mason').setup({})
require('mason-lspconfig').setup({
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
	},
})

-- Autocompletion
local cmp = require('cmp')
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
  },
  mapping = cmp.mapping.preset.insert({
	  -- Navigate between completion items
	  ['<C-p>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
	  ['<C-n>'] = cmp.mapping.select_next_item({behavior = 'select'}),

	  -- `Enter` key to confirm completion
	  ['<CR>'] = cmp.mapping.confirm({select = true}),

	  -- Ctrl+Space to trigger completion menu
	  ['<C-Space>'] = cmp.mapping.complete(),

	  -- Tab to expand snippet at point
	  ['<Tab>'] = cmp.mapping(function(fallback)
		  local luasnip = require('luasnip')
		  local col = vim.fn.col('.') - 1

		  if cmp.visible() then
			  cmp.select_next_item({behavior = 'select'})
		  elseif luasnip.expand_or_locally_jumpable() then
			  luasnip.expand_or_jump()
		  elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
			  fallback()
		  else
			  cmp.complete()
		  end
	  end, {'i', 's'}),

	  -- Scroll up and down in the completion documentation
	  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
	  ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
	    require('luasnip').lsp_expand(args.body)
    end,
  },
})
