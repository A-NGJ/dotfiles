return {
    {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
        require("mason").setup()
    end
    },
    {
         "williamboman/mason-lspconfig.nvim",
         lazy = false,
         config = function()
             require("mason-lspconfig").setup({
                     ensure_installed = { "lua_ls", "pyright", "terraformls"}
                 })
         end
    }
}
