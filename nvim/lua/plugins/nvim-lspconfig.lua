return {
    {
    'neovim/nvim-lspconfig',
    lazy = false
    },
    vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
}


