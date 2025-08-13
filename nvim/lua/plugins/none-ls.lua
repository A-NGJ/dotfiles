return {
    'nvimtools/none-ls.nvim',
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.sql_formatter,
                null_ls.builtins.formatting.prettier.with({
                    extra_args = {
                        "--tab-width", "2"
                    }
                }),
                null_ls.builtins.formatting.isort.with({
                    extra_args = {
                        "--multi-line", "3",
                        "--trailing-comma",
                        "--line-length", "120",
                    },
                }),
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = {
                        "--ignore-missing-imports",
                        "--show-column-numbers"
                    },
                }),
            },
            timeout = 2000
        })
    end
}
