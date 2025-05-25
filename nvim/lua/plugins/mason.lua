return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end
    },
    -- {
    --     "williamboman/mason-lspconfig.nvim",
    --     lazy = false,
    --     dependencies = {
    --         "neovim/nvim-lspconfig",
    --     },
    --     config = function()
    --         require("mason-lspconfig").setup({
    --             ensure_installed = {"lua_ls", "pyright", "terraformls"}
    --         })
    --
    --         require("mason-lspconfig").setup_handlers({
    --             automatic_enable = true,
    --             -- Add any server-specific configurations here if needed
    --         })
    --     end
    -- }
}
