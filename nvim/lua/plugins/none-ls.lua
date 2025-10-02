return {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
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
                null_ls.builtins.diagnostics.markdownlint,
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = function()
                        local args = {
                            "--ignore-missing-imports",
                            "--show-column-numbers",
                            "--disable-error-code",
                            "unused-ignore"
                        }

                        -- Check if .venv exists (uv creates this by default)
                        local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
                        if vim.fn.executable(venv_python) == 1 then
                            table.insert(args, "--python-executable")
                            table.insert(args, venv_python)
                        end

                        return args
                    end,
                }),
            },
            timeout = 2000,
        })
    end
}
