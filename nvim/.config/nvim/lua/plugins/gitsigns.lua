return {
	'lewis6991/gitsigns.nvim',
    config = function()
        require("gitsigns").setup()

        vim.keymap.set("n", "<leader>gpr", ":Gitsigns preview_hunk<CR>",
          {silent = true, noremap = true, desc = "[G]it [Pr]eview"}
        )
    end
}
