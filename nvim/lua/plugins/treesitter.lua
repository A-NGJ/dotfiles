return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local config = require("nvim-treesitter.configs")
            config.setup({
                auto_install = true,
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "go", "terraform" },
                highlight = { enable = true },
                indent = { enable = true },
            })
            local keymap_opts = { noremap = true, silent = true }
            -- vim.keymap.set('n', 'fc', 'zc', keymap_opts, { desc = "[F]old [C]lose" })
            vim.api.nvim_set_keymap("n", "<leader>fO", "zR", { desc = "[F]old [O]pen all" , noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fC", "zM", { desc = "[F]old [C]lose all" , noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>ft", "za", { desc = "[F]old [t]oggle" , noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fc", "zc", { desc = "[F]old [c]lose" , noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fo", "zo", { desc = "[F]old [o]pen" , noremap = true, silent = true })
        end
    }
}
