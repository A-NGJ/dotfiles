return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        lazygit = {},
        bigfile = { enabled = true },
        bufdelete = {},
        dashboard = { enabled = true },
        explorer = { enabled = true },
        git = {},
        indent = { enabled = true },
        input = { enabled = true, win = { animate = false } },
        picker = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        -- scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
    keys = {
        -- Top Pickers and Explorer
        { "<leader>ff",  function() Snacks.picker.smart({ hidden = true }) end, desc = "Find Files" },
        { "<leader>fb",  function() Snacks.picker.buffers() end,         desc = "Find Buffers" },
        { "<leader>fg",  function() Snacks.picker.grep({ hidden = true }) end, desc = "Find by Grep" },
        { "<leader>fh",  function() Snacks.picker.command_history() end, desc = "Find Command History" },
        { "<leader>fn",  function() Snacks.picker.notifications() end,   desc = "Find Notification History" },
        { "<leader>e",   function() Snacks.explorer() end,               desc = "File Explorer" },
        -- git
        { "<leader>lg",  function() Snacks.lazygit() end,                desc = "Lazygit" },
        { "<leader>gb",  function() Snacks.picker.git_branches() end,    desc = "Git Branches" },
        { "<leader>gl",  function() Snacks.picker.git_log() end,         desc = "Git Log" },
        { "<leader>gL",  function() Snacks.picker.git_log_line() end,    desc = "Git Log Line" },
        { "<leader>gs",  function() Snacks.picker.git_status() end,      desc = "Git Status" },
        { "<leader>gS",  function() Snacks.picker.git_stash() end,       desc = "Git Stash" },
        { "<leader>gd",  function() Snacks.picker.git_diff() end,        desc = "Git Diff (Hunks)" },
        { "<leader>gf",  function() Snacks.picker.git_log_file() end,    desc = "Git Log File" },
        { "<leader>gB",  function() Snacks.git.blame_line() end,         desc = "Toggle git blame" },
        -- words
        { "<leader>ww",  function() Snacks.words.jump(1, true) end,      desc = "Jump to Next Word" },
        -- bufdelete
        { "<leader>bdo", function() Snacks.bufdelete.other() end },
        -- diagnostics
        { "<leader>fd",  function() Snacks.picker.diagnostics() end,     desc = "Find Diagnostics" },
    },
}
