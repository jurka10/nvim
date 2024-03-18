local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
        end
    })

    lsp_zero.default_keymaps({ buffer = bufnr })
end)

lsp_zero.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ['omnisharp'] = { 'cs' },
        ['lua_ls'] = { 'lua' },
        ['html'] = { 'html' }
    }
})

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        "lua_ls",
        "omnisharp",
        "tsserver",
        "htmx",
        "html"
    },
    handlers = {
        lsp_zero.default_setup,
        omnisharp = function()
            require 'lspconfig'.omnisharp.setup {
                handlers = { ['textDocument/definition'] = require('omnisharp_extended').handler }
            }
        end,
        html = function()
            require 'lspconfig'.html.setup {}
        end,
        htmx = function()
            require 'lspconfig'.htmx.setup {}
        end,
        lua_ls = function()
            require 'lspconfig'.lua_ls.setup {}
        end
    },
})
