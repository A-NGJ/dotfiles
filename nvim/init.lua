require('config.lazy')
-- require('mini.ai').setup()
-- require('mini.surround').setup()
-- require('plugins.mini')
vim.o.statusline = "%f"

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Insert mode tab behavior (needs a mapping):
vim.api.nvim_set_keymap("i", "<S-Tab>", "<C-d>", { noremap = true })
vim.api.nvim_set_keymap("n", "<CR>", ":nohlsearch<CR><CR>", { noremap = true })

-- Line Numbers:
vim.o.number = true

-- Search:
vim.o.hlsearch = true
vim.o.incsearch = true

-- Tab Completion:
vim.o.wildmenu = true

-- Scrolling:
vim.o.scrolloff = 5

-- Case Sensitivity:
vim.o.ignorecase = true
vim.o.smartcase = true

-- Line Wrap:
vim.o.linebreak = true -- 'lbr' equivalent

-- Auto Indent:
-- vim.o.autoindent = true
-- vim.o.smartindent = true

-- Command Line:
vim.o.showcmd = true
vim.o.backspace = "indent,eol,start"

-- Timeouts:
vim.o.ttimeout = true
vim.o.ttimeoutlen = 100
vim.o.timeoutlen = 3000

vim.keymap.set("i", "jk", "<Esc>", { noremap = true })

-- LSP formatting
vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, { noremap = true, silent = true, desc = "[F]ormat [F]ile" })

-- Yank to clipboard
vim.o.clipboard = "unnamedplus"

local on_attach = function(_, bufnr)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = '[R]e[N]ame' })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })

    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = '[G]o [D]efinition' })
    vim.keymap.set("n", "<leader>gd", require("telescope.builtin").lsp_definitions, { desc = '[G]o [D]efinition' })
    -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = '[G]o [I]mplementation' })
    vim.keymap.set("n", "<leader>gi", require("telescope.builtin").lsp_implementations, { desc = '[G]o [I]mplementation' })
    vim.keymap.set("n", "<leader>gr", require("telescope.builtin").lsp_references, { desc = '[G]o [R]eferences' })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = 'Hover' })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config.lua_ls = {
    cmd = { 'lua-language-server' },
    root_patterns = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    on_attach = on_attach,
    capabilities = capabilities
}

vim.lsp.config.pyright = {
    cmd = { 'pyright-langserver', '--stdio' },
    root_patterns = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        pyright = {
            disableOrganizeImports = true, -- Using Ruff
            reportGeneralTypeIssue = false,
        },
        python = {
            analysis = {
                ignore = { '*' }, -- Ignore all files for analysis,
                typeCheckingMode = "off", -- Disable type checking
            }
        }
    },
}

vim.lsp.config.ruff = {
    cmd = { 'ruff', 'server' },
    root_patterns = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ruff = {
            lineLength = 120, -- Set the line length to 120 characters
        },
    },
}

vim.lsp.config.terraformls = {
    cmd = { 'terraform-ls', 'serve' },
    root_patterns = { '.terraform', '*.tf', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
}



vim.lsp.config.yamlls = {
    cmd = { 'yaml-language-server', '--stdio' },
    root_patterns = { '.git' },
    on_attach = on_attach,
    capabilities = capabilities
}

vim.lsp.config.ts_ls = {
    cmd = { 'typescript-language-server', '--stdio' },
    root_patterns = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    settings = {
        typescript = {
            format = {
                insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
                insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = true,
            },
            preferences = {
                useAsteriskForMultiLineComments = true, -- Enables /* */ style comments
            }
        }
    },
}

-- Enable LSP servers automatically
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local bufnr = args.buf
        local filetype = vim.bo[bufnr].filetype

        -- Map filetypes to LSP server names
        local servers = {
            lua = "lua_ls",
            terraform = "terraformls",
            yaml = "yamlls",
            typescript = "ts_ls",
            typescriptreact = "ts_ls",
        }

        local server_name = servers[filetype]
        if server_name then
            vim.lsp.enable(server_name, { bufnr = bufnr })
        end

        -- Enable pyright and ruff only for Python files
        if filetype == "python" then
            vim.lsp.enable("pyright", { bufnr = bufnr })
            vim.lsp.enable("ruff", { bufnr = bufnr })
        end
    end,
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
    callback = function(ev)
        vim.bo[ev.buf].commentstring = "# %s"
    end,
    pattern = { "terraform", "hcl" },
})

-- vim.api.nvim_create_autocmd("FileType", {
--     group = vim.api.nvim_create_augroup("FixTypeScriptCommentString", { clear = true }),
--     callback = function(ev)
--         vim.bo[ev.buf].commentstring = "/* %s */"
--     end,
--     pattern = { "typescript", "typescriptreact", "typescript.tsx" },
-- })

vim.filetype.add {
    extension = {
        sql = "sql",
    },
}

-- Add the commentstring for SQL files
vim.bo.commentstring = "-- %s"

-- TypeScript specific settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "typescriptreact", "terraform" },
    callback = function()
        vim.opt_local.shiftwidth = 2   -- Number of spaces for auto-indent
        vim.opt_local.tabstop = 2      -- Number of spaces a tab counts for
        vim.opt_local.softtabstop = 2  -- Number of spaces for a tab while editing
        vim.opt_local.expandtab = true -- Use spaces instead of tabs
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "toml", "yaml" },
    callback = function()
        vim.opt_local.shiftwidth = 2   -- Number of spaces for auto-indent
        vim.opt_local.tabstop = 2      -- Number of spaces a tab counts for
        vim.opt_local.softtabstop = 2  -- Number of spaces for a tab while editing
        vim.opt_local.expandtab = true -- Use spaces instead of tabs
    end,
})

vim.api.nvim_set_keymap("n", "<C-W><Up>", ":resize +4<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-W><Down>", ":resize -4<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-W><Left>", ":vertical resize -4<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-W><Right>", ":vertical resize +4<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>cp", ":let @+ = expand('%:p')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>cr", ":let @+ = expand('%')<CR>", { noremap = true, silent = true })

-- Custom LspInfo command using built-in vim.lsp functions
vim.api.nvim_create_user_command('LspInfo', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    if #clients == 0 then
        print("No LSP clients attached to current buffer")
        return
    end

    print("LSP clients attached to current buffer:")
    print("=======================================")

    for _, client in ipairs(clients) do
        local status = client.is_stopped() and "stopped" or "running"
        print(string.format("• %s (id: %d, status: %s)", client.name, client.id, status))

        if client.config.root_dir then
            print(string.format("  Root: %s", client.config.root_dir))
        end

        if client.config.filetypes then
            print(string.format("  Filetypes: %s", table.concat(client.config.filetypes, ", ")))
        end

        print("")
    end

    -- Also show global LSP info
    local all_clients = vim.lsp.get_clients()
    print(string.format("Total LSP clients running: %d", #all_clients))
end, { desc = 'Show LSP client information' })

