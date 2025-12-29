return {
    'vim-test/vim-test',
    dependencies = {
        'preservim/vimux',
    },
    config = function()
        vim.keymap.set("n", "<leader>Tn", "<cmd>TestNearest<cr>", { desc = "Run [T]est nearest" })
        vim.keymap.set("n", "<leader>Tf", "<cmd>TestFile<cr>", { desc = "Run [T]est file" })
        vim.keymap.set("n", "<leader>Tl", "<cmd>TestLast<cr>", { desc = "Run [T]est [L]ast" })
        vim.keymap.set("n", "<leader>Ta", "<cmd>TestSuite<cr>", { desc = "Run [T]est [A]ll" })
        vim.keymap.set("n", "<leader>Tv", "<cmd>TestVisit<cr>", { desc = "Run [T]est [F]ile" })
        vim.cmd("let test#strategy = 'vimux'")
    end
}
