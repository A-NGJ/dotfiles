return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      -- Setup mini.nvim modules
      require('mini.ai').setup()
      require('mini.surround').setup()
      require('mini.pairs').setup()
      require('mini.files').setup()

      vim.api.nvim_create_user_command('MiniFiles', function()
        require('mini.files').open()
      end, {})
    end
}
