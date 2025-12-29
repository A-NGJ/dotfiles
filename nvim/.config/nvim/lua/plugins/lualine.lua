return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup {
            sections = {
                lualine_c = {
                    {
                        'diagnostics',
                        sources = { 'nvim_lsp' },               -- Display LSP diagnostics
                        sections = { 'error', 'warn', 'info', 'hint' }, -- Diagnostic types to show
                        diagnostics_color = {                   -- Customize colors (optional)
                            error = 'DiagnosticError',
                            warn  = 'DiagnosticWarn',
                            info  = 'DiagnosticInfo',
                            hint  = 'DiagnosticHint',
                        },
                    },
                    {
                        'filename',
                        file_status = true, -- Display file status (readonly, modified, unmodifiable)
                        path = 1    -- 0 = just filename, 1 = relative path, 2 = absolute path
                    }
                    -- ... other sections ...
                }
                -- ... other lualine options ...
            },
            options = {
                theme = "catppuccin"
            }
        }
    end
}
