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
        end,
    },
}
