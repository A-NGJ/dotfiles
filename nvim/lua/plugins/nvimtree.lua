local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings

  vim.keymap.set('n', 't',   api.node.open.tab,                   opts('Open: New Tab'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end

return
{
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    requires = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup({
            vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<enter>", { noremap = false }),
            vim.api.nvim_set_keymap("n", "<leader>tf", ":NvimTreeFocus<enter>", { noremap = false }),
            on_attach = my_on_attach,
            vim.keymap.set("n", "<leader>tff", "<cmd>NvimTreeFindFile<CR>", { desc = "[T]ree [F]ind [F]ile" })
            -- vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
            -- vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
        })
    end
}
