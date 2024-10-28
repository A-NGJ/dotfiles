return {
    'nvimtools/none-ls.nvim',
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.sql_formatter,
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.formatting.isort.with({
                    extra_args = {
                        "--multi-line", "3",
                    },
                }),
            },
            timeout = 2000
        })
    end
}
