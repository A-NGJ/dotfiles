return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "github/copilot.vim",
    },
    opts = {
        model = "claude-3.7-sonnet",
        chat_autocomplete = false,
        sticky = {
            -- "/NO_CODE"
        },
        mappings = {
            reset = {
                normal = '<c-o>',
                insert = '<c-o>',
            },
            complete = {
                insert = '<c-space>'
            }
        },
        prompts = {
            NO_CODE = {
                system_prompt = [[ 
                You are a programming instructor focused on clear, practical explanations.

                Do not code anything, just explain to me. You are allowed to use code snippets in the explanation, but do not
                write code as an answer.

                Additional instructions:
                - Focus on explaining concepts rather than providing solutions
                - Include relevant programming principles and patterns
                - When showing code snippets, annotate them with explanatory comments
                - Refer to the documentation if applicable
                ]]
            },
        },

        -- contexts = {
        --     file = {
        --         description = 'Includes content of provided file in chat context. Supports input.',
        --         input = function(callback, source)
        --             local utils = require('CopilotChat.utils')
        --             local cwd = utils.win_cwd(source.winnr)
        --
        --             -- Use Telescope with fzf to select a file
        --             require('telescope.builtin').find_files({
        --                 prompt_title = 'Select a file',
        --                 cwd = cwd,
        --                 attach_mappings = function(prompt_bufnr, map)
        --                     local actions = require('telescope.actions')
        --                     local action_state = require('telescope.actions.state')
        --
        --                     actions.select_default:replace(function()
        --                         local selection = action_state.get_selected_entry()
        --                         actions.close(prompt_bufnr)
        --                         callback(selection.path)
        --                     end)
        --
        --                     return true
        --                 end,
        --             })
        --         end,
        --         resolve = function(input)
        --             local context = require('CopilotChat.context')
        --             return {
        --                 context.file(input),
        --             }
        --         end,
        --     }
        -- }
    },
    -- build = function()
    --     vim.cmd("UpdateRemotePlugins")
    -- end,
    build = "make tiktoken",
    event = "VeryLazy",
    keys = {
        { "<leader>ccc", "<cmd>CopilotChat<cr>", desc = "CopilotChat - Chat" },
        { "<leader>ccm", "<cmd>CopilotChatCommit<cr>", desc = "CopilotChat - Commit" },
        { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
        { "<leader>cct", "<cmd>CopilotChatTests<cr>",   desc = "CopilotChat - Generate tests" },
        {
            "<leader>ccp",
            function()
                local actions = require("CopilotChat.actions")
                require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
            end,
            desc = "CopilotChat - Prompt actions",
        },
        {
            "<leader>ccq",
            function()
                local input = vim.fn.input("Quick Chat: ")
                if input ~= "" then
                    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
                end
            end,
            desc = "CopilotChat - Quick chat",
        }
    },
}
