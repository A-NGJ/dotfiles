return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
          'hrsh7th/cmp-nvim-lsp',
          "L3MON4D3/LuaSnip"
        },
        config = function()
            local cmp = require("cmp")

        -- require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
          performance = {
            max_view_entries = 10
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          completion = {
            -- autocomplete = {
            --   cmp.TriggerEvent.TextChanged,
            -- },
          },
          mapping = cmp.mapping.preset.insert({
              ['<C-j>'] = cmp.mapping.scroll_docs(-4),
              ['<C-k>'] = cmp.mapping.scroll_docs(4),
              ['<C-o>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          }, {
            { name = 'buffer' },
          }),
        })
        end
    }
}
