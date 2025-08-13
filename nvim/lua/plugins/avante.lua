return {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        -- add any opts here
        -- for example
        mode = "legacy",
        provider = "netlight_gpt_5_mini",
        system_prompt = [[
            You are an coding expert that specializes in providing accurate and helpful answers to programming-related questions. You are straight to the point engineer.

            When I ask you a question reformulate the question so that you can provide better results.
            Then, generate three additional questions that would help you give a more accurate answer.
            Make assumptions to these questions and combine the answers to produce the final answers to my original question.
            State the assumptions you are making before answering the question.
            I want you to give me a TLDR for long responses

            Wrap all code examples in markdown code blocks.
            ]],
        providers = {
            ["netlight_claude_4"] = {
                __inherited_from = "claude",
                endpoint = "https://llm-proxy.edgez.live",
                model = "bedrock-claude-v4.0",
                timeout = 30000,
                api_key_name = "NETLIGHT_CODEPILOT_API_KEY",
                -- disable_tools = {"python"},
                extra_request_body = {
                    temperature = 0
                }
            },
            ["netlight_gpt_5"] = {
                __inherited_from = "openai",
                endpoint = "https://llm-proxy.edgez.live",
                model = "gpt-5",
                timeout = 30000,
                api_key_name = "NETLIGHT_CODEPILOT_API_KEY",
                -- disable_tools = {"python"},
                extra_request_body = {
                    temperature = 1
                }
            },
            ["netlight_gpt_5_mini"] = {
                __inherited_from = "openai",
                endpoint = "https://llm-proxy.edgez.live",
                model = "gpt-5-mini",
                timeout = 30000,
                api_key_name = "NETLIGHT_CODEPILOT_API_KEY",
                -- disable_tools = {"python"},
                extra_request_body = {
                    temperature = 1
                }
            },
            ["netlight_gpt_o4_high"] = {
                __inherited_from = "openai",
                endpoint = "https://llm-proxy.edgez.live",
                model = "gpt-o4-high",
                timeout = 30000,
                api_key_name = "NETLIGHT_CODEPILOT_API_KEY",
                -- disable_tools = {"python"},
                extra_request_body = {
                    temperature = 1
                }
            }
        },
        shortcuts = {
            {
                name = "commit",
                description = "Write a commit message",
                details = "This will generate a commit message based on the current changes in the file.",
                prompt = [[ Run git_diff tool to gather the current staged/working tree changes. Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.]]
            },
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        -- "echasnovski/mini.pick",     -- for file_selector provider mini.pick
        -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
        -- "ibhagwan/fzf-lua",          -- for file_selector provider fzf
        "stevearc/dressing.nvim",      -- for input provider dressing
        "folke/snacks.nvim",           -- for input provider snacks
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        -- "zbirenbaum/copilot.lua",    -- for providers='copilot'
        -- {
        --     -- support for image pasting
        --     "HakonHarnes/img-clip.nvim",
        --     event = "VeryLazy",
        --     opts = {
        --         -- recommended settings
        --         default = {
        --             embed_image_as_base64 = false,
        --             prompt_for_file_name = false,
        --             drag_and_drop = {
        --                 insert_mode = true,
        --             },
        --             -- required for Windows users
        --             use_absolute_path = true,
        --         },
        --     },
        -- },
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
