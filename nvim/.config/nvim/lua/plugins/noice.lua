return {
    "folke/noice.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    opts = {
        cmdline = { enabled = true },
        messages = { enabled = false },
        popupmenu = { enabled = false },
        notify = { enabled = false },
        lsp = {
            progress = { enabled = false },
            message = { enabled = false },
            hover = { enabled = false },
            signature = { enabled = false },
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
        },
    },
}
