return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    -- @module 'render-markdown'
    -- @type render.md.UserConfig
    opts = {},
    config = function()
        vim.keymap.set("n", "<leader>rmm", function()
            require("render-markdown").enable()
        end, { desc = "[R]ender [M]arkdown" })

        vim.keymap.set("n", "<leader>rmd", function()
            require("render-markdown").disable()
        end, { desc = "[R]ender [M]arkdown [D]isable" })
    end
}
