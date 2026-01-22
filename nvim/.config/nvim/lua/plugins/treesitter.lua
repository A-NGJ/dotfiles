return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local config = require("nvim-treesitter.configs")
            config.setup({
                auto_install = true,
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "go", "terraform", "typescript" },
                highlight = { enable = true },
                indent = { enable = false },
                enable = true,
                enable_autocmd = false,
                fold = {
                    enable = true,
                    -- custom_folding_ranges = {
                    --     python = {
                    --         ["class"] = {start = "class_definition", end = "block"},
                    --         ["function"] = {start = "function_definition", end = "block"},
                    --     },
                    -- }
                },

                lookahead = true,
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["aF"] = "@function.outer",
                            ["iF"] = "@function.inner",
                            ["aC"] = "@class.outer",
                            -- You can optionally set descriptions to the mappings (used in the desc parameter of
                            -- nvim_buf_set_keymap) which plugins like which-key display
                            ["iC"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            -- You can also use captures from other query groups like `locals.scm`
                            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                        },
                        -- You can choose the select mode (default is charwise 'v')
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * method: eg 'v' or 'o'
                        -- and should return the mode ('v', 'V', or '<c-v>') or a table
                        -- mapping query_strings to modes.
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        -- If you set this to `true` (default is `false`) then any textobject is
                        -- extended to include preceding or succeeding whitespace. Succeeding
                        -- whitespace has priority in order to act similarly to eg the built-in
                        -- `ap`.
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * selection_mode: eg 'v'
                        -- and should return true or false
                        include_surrounding_whitespace = true,
                    },
                },
            })
            local keymap_opts = { noremap = true, silent = true }
            -- vim.keymap.set('n', 'fc', 'zc', keymap_opts, { desc = "[F]old [C]lose" })
            vim.api.nvim_set_keymap("n", "<leader>fO", "zR",
                { desc = "[F]old [O]pen all", noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fC", "zM",
                { desc = "[F]old [C]lose all", noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>ft", "za", { desc = "[F]old [t]oggle", noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fc", "zc", { desc = "[F]old [c]lose", noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fo", "zo", { desc = "[F]old [o]pen", noremap = true, silent = true })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter', -- Ensure it loads after nvim-treesitter
    },
}
