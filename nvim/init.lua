require('config.lazy')
require('plugins.neogit')
require('plugins.nvimtree')

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

-- Yank to clipboard
vim.o.clipboard = "unnamedplus"

local on_attach = function(_, bufnr)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = '[R]e[N]ame' })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = '[G]o [D]efinition' })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = '[G]o [I]mplementation' })
    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = '[G]o [R]eferences' })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = 'Hover' })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
require("lspconfig").terraformls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

require("lspconfig").yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

require("lspconfig").tsserver.setup {
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
        vim.opt_local.shiftwidth = 2 -- Number of spaces for auto-indent
        vim.opt_local.tabstop = 2  -- Number of spaces a tab counts for
        vim.opt_local.softtabstop = 2 -- Number of spaces for a tab while editing
        vim.opt_local.expandtab = true -- Use spaces instead of tabs
    end,
})

