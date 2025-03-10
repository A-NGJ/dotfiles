return {
    'ThePrimeagen/harpoon',
    depends = { 'nvim-lua/plenary.nvim' },
    config = function()
        local mark = require('harpoon.mark')
        local ui = require('harpoon.ui')

        require('harpoon').setup()

        vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[H]arpoon [Add] file" })
        vim.keymap.set("n", "<leader>hm", ui.toggle_quick_menu, { desc = "[H]arpoon [T]oggle quick menu" })
    end
}
