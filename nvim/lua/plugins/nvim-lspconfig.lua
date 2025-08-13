return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        config = function()
            -- Set up each LSP server
            -- Key mappings for LSP functions
            vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>lua vim.lsp.buf.format()<CR>',
                { noremap = true, silent = true })
            -- vim.diagnostic.config({
            --     virtual_text = true,
            --     signs = true,
            --     update_in_insert = false,
            --     underline = true,
            --     severity_sort = true,
            -- })
        end
    }
}
