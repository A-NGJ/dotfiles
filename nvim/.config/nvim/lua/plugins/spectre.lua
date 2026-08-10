return {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Spectre",
    keys = {
        {
            "<leader>ss",
            function() require("spectre").toggle() end,
            desc = "[S]pectre [S]earch (project)",
        },
        {
            "<leader>sw",
            function() require("spectre").open_visual({ select_word = true }) end,
            desc = "[S]pectre [W]ord under cursor",
        },
        {
            "<leader>sw",
            function() require("spectre").open_visual() end,
            mode = "v",
            desc = "[S]pectre selection",
        },
        {
            "<leader>sf",
            function() require("spectre").open_file_search({ select_word = true }) end,
            desc = "[S]pectre current [F]ile",
        },
    },
}
