return {
    "folke/noice.nvim",
    config = function()
        require("noice").setup({
            -- add any options here
            routes = {
                {
                    filter = {
                        event = 'msg_show',
                        any = {
                            { find = "written" },
                            { find = '%d+L, %d+B' },
                            { find = '; after #%d+' },
                            { find = '; before #%d+' },
                            { find = '%d fewer lines' },
                            { find = '%d more lines' },
                        },
                    },
                    opts = { skip = true },
                },
                {
                    filter = {
                        event = "notify",
                        find = "No information available",
                    },
                    opts = {
                        skip = true,
                    },
                },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = 5,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = 8,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                    },
                },
            },
            messages = {
                enabled = false,
            }
        })
    end,
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    }
}
