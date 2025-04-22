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

        vim.keymap.set('n', '<C-n>', function()
            require('mini.files').open()
        end, { desc = 'Open file explorer' })

        vim.keymap.set('n', '<leader>tr', function()
            -- Get the current buffer's file path
            local current_file = vim.api.nvim_buf_get_name(0)
            if current_file == '' then
                -- No file is open
                require('mini.files').open()
                return
            end
            
            -- Open mini.files focused on the directory of current file
            require('mini.files').open(vim.fn.fnamemodify(current_file, ':p:h'))
            
            -- After opening the explorer, move to the file
            -- This part runs asynchronously to ensure mini.files is ready
            -- vim.defer_fn(function()
            --     -- Try to find and focus on the current file
            --     local MiniFiles = require('mini.files')
            --     MiniFiles.go_to(current_file)
            -- end, 10) -- Small delay to ensure explorer is opened
        end, { desc = "Reveal current file in mini.files" })
    end
}
