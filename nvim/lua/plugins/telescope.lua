local M = {}

-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local is_inside_work_tree = {}

M.project_files = function()
  local opts = {} -- define here if you want to define something

  local cwd = vim.fn.getcwd()
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system("git rev-parse --is-inside-work-tree")
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  if is_inside_work_tree[cwd] then
    require("telescope.builtin").git_files(opts)
  else
    require("telescope.builtin").find_files(opts)
  end
end

return {
    {
        'nvim-telescope/telescope.nvim',
        config = function()
            require('telescope').load_extension('harpoon')
            require('telescope').load_extension('git_worktree')

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require('telescope').setup {
                defaults = {
                    layout_strategy = "horizontal",
                    layout_config = {
                        preview_width = 0.65,
                        horizontal = {
                            size = {
                                width = "95%",
                                height = "95%",
                            },
                        },
                    },
                    pickers = {
                        find_files = {
                            theme = "dropdown",
                        }
                    },
                    mappings = {
                        i = {
                            ['<C-u>'] = false,
                            ["<C-j>"] = require('telescope.actions').move_selection_next,
                            ["<C-k>"] = require('telescope.actions').move_selection_previous,
                            ["<C-d>"] = require('telescope.actions').move_selection_previous,
                        },
                    },
                },
            }

            -- Enable telescope fzf native, if installed
            pcall(require('telescope').load_extension, 'fzf')

            -- See `:help telescope.builtin`
            vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
                { desc = '[?] Find recently opened files' })
            vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find,
                { desc = '[/] Fuzzily search in current buffer]' })

            vim.keymap.set('n', '<leader>sf', M.project_files, { desc = '[S]earch [F]iles' })
            -- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').git_files, { desc = '[S]earch [F]iles [G]it' })
            -- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string,
                { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics,
                { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers,
                { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>sS', require('telescope.builtin').git_status, { desc = '' })
            vim.keymap.set('n', '<leader>sr', require('telescope.builtin').lsp_references, { desc = '[S]earch [R]eferences' })
            vim.keymap.set('n', '<c-e>', ":Telescope harpoon marks<CR>", { desc = 'Harpoon [M]arks' })
            -- vim.keymap.set("n", "<Leader>s", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
                -- silent)
            vim.keymap.set("n", "<Leader>sR",
                "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", silent)
            vim.keymap.set("n", "<Leader>sn", "<CMD>lua require('telescope').extensions.notify.notify()<CR>", silent)
            vim.keymap.set('n', '<Leader>gi', require('telescope.builtin').lsp_implementations,
                { desc = '[G]oto [I]mplementation' })

            vim.api.nvim_set_keymap("n", "st", ":TodoTelescope<CR>", { noremap = true })
            vim.api.nvim_set_keymap("n", "<Leader><tab>", "<Cmd>lua require('telescope.builtin').commands()<CR>",
                { noremap = false })
        end
    },
    'nvim-telescope/telescope-symbols.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
}
