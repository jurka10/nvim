local lsp_zero = require('lsp-zero')

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
lsp_zero.on_attach(function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end

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

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        "lua_ls",
        "omnisharp",
        "html",
        "htmx",
        "tailwindcss",
    },
    handlers = {
        lsp_zero.default_setup,
        omnisharp = function()
            require 'lspconfig'.omnisharp.setup({
                handlers = { ['textDocument/definition'] = require('omnisharp_extended').handler }
            })
        end,
        lua_ls = function()
            require 'lspconfig'.lua_ls.setup({})
        end,
        html = function()
            require 'lspconfig'.html.setup({})
        end,
        htmx = function()
            require 'lspconfig'.htmx.setup({})
        end,
        tailwindcss = function()
            require 'lspconfig'.tailwindcss.setup({})
        end,
    },
})
