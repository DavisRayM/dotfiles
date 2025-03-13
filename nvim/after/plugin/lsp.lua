-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- LSP
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

-- Protobuf
configs.protobuf_language_server = {
    default_config = {
        cmd = { '/usr/bin/protobuf-language-server'  },
        filetypes = { 'proto' },
        root_dir = require('lspconfig.util').root_pattern('.git'),
        single_file_support = true,
        settings = { }
    }
}

lspconfig.protobuf_language_server.setup {}

-- CCLS
lspconfig.ccls.setup {
    init_options = {
        compilationDatabaseDirectory = "build";
        index = {
            threads = 0;
        };
        clang = {
            excludeArgs = { "-frounding-math"} ;
        };
    }
}

-- Pyright
lspconfig.pyright.setup {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        }
    }
}

-- Rust
lspconfig.rust_analyzer.setup {
    -- Server-specific settings. See `:help lspconfig-setup`
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            imports = {
                group = {
                    enable = false,
                },
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
        },
    },
}

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

    -- Docs/References etc.
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    -- Diagnostics
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    -- Code actions
    vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    vim.keymap.set('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
  end,
})

-- Autocompletion
local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = cmp.mapping.preset.insert({
	  -- Navigate between completion items
	  ['<C-p>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
	  ['<C-n>'] = cmp.mapping.select_next_item({behavior = 'select'}),

	  -- `Enter` key to confirm completion
	  ['<CR>'] = cmp.mapping.confirm({select = true}),

	  -- Ctrl+Space to trigger completion menu
	  ['<C-Space>'] = cmp.mapping.complete(),

	  -- Scroll up and down in the completion documentation
	  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
	  ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})
