return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        -- Setup mini.nvim modules
        require('mini.ai').setup()
        require('mini.surround').setup()
        require('mini.pairs').setup()
        require('mini.files').setup()
        require('mini.pick').setup()
        require('mini.comment').setup {
            options = {
                custom_commentstring = function()
                    return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
                end,
            },
        }

        vim.api.nvim_create_user_command('MiniFiles', function()
            require('mini.files').open()
        end, {})
    end
}
