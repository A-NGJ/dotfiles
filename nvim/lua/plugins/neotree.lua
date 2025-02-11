return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "muniftanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- optional image support in preview window: see `# preview mode` for more information
    },
    config = function()
        require("neo-tree").setup({
            vim.api.nvim_set_keymap("n", "<c-n>", ":Neotree toggle<enter>", { noremap = false }),
            vim.api.nvim_set_keymap("n", "<leader>tf", ":Neotree focus<enter>", { noremap = false }),
            -- on_attach = my_on_attach,
            -- vim.keymap.set("n", "<leader>tff", "<cmd>nvimtreefindfile<cr>", { desc = "[t]ree [f]ind [f]ile" })
            -- vim.keymap.set("n", "<leader>ec", "<cmd>nvimtreecollapse<cr>", { desc = "collapse file explorer" })
            -- vim.keymap.set("n", "<leader>er", "<cmd>nvimtreerefresh<cr>", { desc = "refresh file explorer" })
            window = {
                mappings = {
                    ["l"] = "open",
                    -- ["o?"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
                }
            }
        })
    end
}
