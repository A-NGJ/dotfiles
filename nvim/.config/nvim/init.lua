require('config.lazy')
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
vim.o.scrolloff = 20

-- Case Sensitivity:
vim.o.ignorecase = true
vim.o.smartcase = true

-- Line Wrap:
vim.o.linebreak = true -- 'lbr' equivalent

-- Auto Indent:
vim.o.autoindent = true
vim.o.smartindent = true -- Conflict with treesitter indent

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
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = '[R]e[N]ame', buffer = bufnr })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = '[C]ode [A]ction', buffer = bufnr })

    -- Native LSP go-to-definition (works without Telescope)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = '[G]o [D]efinition', buffer = bufnr })
    -- Telescope version for split views
    vim.keymap.set("n", "<leader>gd", require("telescope.builtin").lsp_definitions,
        { desc = '[G]o [D]efinition (Telescope)', buffer = bufnr })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = '[G]o [I]mplementation', buffer = bufnr })
    vim.keymap.set("n", "<leader>gi", require("telescope.builtin").lsp_implementations,
        { desc = '[G]o [I]mplementation (Telescope)', buffer = bufnr })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = '[G]o [R]eferences', buffer = bufnr })
    vim.keymap.set("n", "<leader>gr", require("telescope.builtin").lsp_references,
        { desc = '[G]o [R]eferences (Telescope)', buffer = bufnr })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = 'Hover', buffer = bufnr })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config.lua_ls = {
    cmd = { 'lua-language-server' },
    root_patterns = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    filetypes = { 'lua' },
    on_attach = on_attach,
    capabilities = capabilities
}

vim.lsp.config.pyright = {
    cmd = { 'pyright-langserver', '--stdio' },
    root_patterns = { 'pyproject.toml', 'pyrightconfig.json', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
    filetypes = { 'python' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off",
                reportMissingImports = "warning"
            }
        }
    }
}

vim.lsp.config.ruff = {
    cmd = { 'ruff', 'server' },
    root_patterns = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    filetypes = { 'python' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ruff = {
            lineLength = 120, -- Set the line length to 120 characters
        },
    },
}

vim.lsp.config.ty = {
    cmd = { 'ty', 'server' },
    root_patterns = { 'pyproject.toml', 'ty.toml', '.git' },
    filetypes = { 'python' },
    on_attach = on_attach,
    capabilities = capabilities,
}

vim.lsp.config.terraformls = {
    cmd = { 'terraform-ls', 'serve' },
    root_patterns = { '.terraform', '.git' },
    filetypes = { 'terraform', 'hcl' },
    on_attach = on_attach,
    capabilities = capabilities,
}

vim.lsp.config.yamlls = {
    cmd = { 'yaml-language-server', '--stdio' },
    root_patterns = { '.git' },
    filetypes = { 'yaml' },
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

vim.lsp.config.gopls = {
    cmd = { 'gopls' },
    root_patterns = { 'go.mod', '.git' },
    filetypes = { 'go', 'gomod' },
    on_attach = on_attach,
    capabilities = capabilities
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
            go = "gopls",
            gomod = "gopls",
        }

        -- Python: use ty (type checker) + ruff (linter)
        if filetype == "python" then
            vim.lsp.enable("ty", { bufnr = bufnr })
            vim.lsp.enable("ruff", { bufnr = bufnr })
        else
            local server_name = servers[filetype]
            if server_name then
                vim.lsp.enable(server_name, { bufnr = bufnr })
            end
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

-- -- Lazygit
-- vim.keymap.set(
--     "n",
--     "<leader>lg",
--     ":LazyGit<CR>",
--     { noremap = true, silent = true, desc = "[L]azy[G]it" }
-- )
