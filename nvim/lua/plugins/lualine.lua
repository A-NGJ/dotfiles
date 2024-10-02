return {
	'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup {
          -- sections = {
          --   lualine_c = { 
          --     {
          --       'diagnostics', 
          --       sources = { 'nvim_lsp' }, -- Display LSP diagnostics
          --       sections = { 'error', 'warn', 'info', 'hint' }, -- Diagnostic types to show
          --       diagnostics_color = { -- Customize colors (optional)
          --         error = 'DiagnosticError',
          --         warn  = 'DiagnosticWarn',
          --         info  = 'DiagnosticInfo',
          --         hint  = 'DiagnosticHint',
          --       },
          --     }
          --   },
          --   -- ... other sections ...
          -- },
          -- ... other lualine options ...
        }
    end
}
