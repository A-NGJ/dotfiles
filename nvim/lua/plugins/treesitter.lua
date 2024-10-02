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
                -- indent = { enable = true },
            })
            local keymap_opts = { noremap = true, silent = true }
            -- vim.keymap.set('n', 'fc', 'zc', keymap_opts, { desc = "[F]old [C]lose" })
            vim.api.nvim_set_keymap("n", "fc", "zc", { desc = "[F]old [C]lose" , noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "fo", "zo", { desc = "[F]old [O]pen" , noremap = true, silent = true })
        end
    }
}
