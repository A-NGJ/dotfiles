return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup()

            local ensure_installed = {
                "go", "gomod", "hcl", "lua", "markdown", "markdown_inline",
                "python", "sql", "terraform", "typescript", "yaml",
            }
            require("nvim-treesitter").install(ensure_installed)

            -- main branch no longer auto-enables features from opts;
            -- start highlighting + indentation per buffer.
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local ft = args.match
                    -- only act if a parser is available for this filetype
                    local ok, parser = pcall(vim.treesitter.get_parser, args.buf, nil, { error = false })
                    if not ok or not parser then
                        return
                    end
                    vim.treesitter.start(args.buf)
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                },
                move = {
                    set_jumps = true,
                },
            })

            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")

            -- select: <op>if = inner function, <op>af = around function, etc.
            -- f = function, c = class, a = argument/parameter, o = loop, i = conditional
            local selects = {
                ["if"] = "@function.inner",
                ["af"] = "@function.outer",
                ["ic"] = "@class.inner",
                ["ac"] = "@class.outer",
                ["ia"] = "@parameter.inner",
                ["aa"] = "@parameter.outer",
                ["io"] = "@loop.inner",
                ["ao"] = "@loop.outer",
                ["ii"] = "@conditional.inner",
                ["ai"] = "@conditional.outer",
            }
            for keys, capture in pairs(selects) do
                vim.keymap.set({ "x", "o" }, keys, function()
                    select.select_textobject(capture, "textobjects")
                end, { desc = "textobject " .. capture })
            end

            -- move: ]f / [f jump to next / previous function start, ]F / [F to its end.
            local moves = {
                ["@function.outer"] = "f",
                ["@class.outer"] = "c",
                ["@parameter.inner"] = "a",
            }
            for capture, key in pairs(moves) do
                vim.keymap.set({ "n", "x", "o" }, "]" .. key, function()
                    move.goto_next_start(capture, "textobjects")
                end, { desc = "next start " .. capture })
                vim.keymap.set({ "n", "x", "o" }, "[" .. key, function()
                    move.goto_previous_start(capture, "textobjects")
                end, { desc = "prev start " .. capture })
                vim.keymap.set({ "n", "x", "o" }, "]" .. key:upper(), function()
                    move.goto_next_end(capture, "textobjects")
                end, { desc = "next end " .. capture })
                vim.keymap.set({ "n", "x", "o" }, "[" .. key:upper(), function()
                    move.goto_previous_end(capture, "textobjects")
                end, { desc = "prev end " .. capture })
            end
        end,
    },
}
