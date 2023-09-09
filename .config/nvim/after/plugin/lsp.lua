local lsp = require('lsp-zero').preset({
  name = 'recommended',
  call_server = 'global'
})

lsp.ensure_installed({
  'lua_ls',
  'rust_analyzer',
})

lsp.set_sign_icons({})

lsp.setup_nvim_cmp({ mapping = cmp_mappings })

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local lsp_format_on_save = function (bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr})
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function ()
            vim.lsp.buf.format()
            filter = function (client)
                return client.name == "null-ls"
            end
        end,
    })
end

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    -- Setup format on save
    lsp_format_on_save(opts.buffer)

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>fr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
end)

require'lspconfig'.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

lsp.setup()

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }


cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({select = false}),
    }
})
