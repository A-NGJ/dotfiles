return {
  -- Install markdown preview, use npx if available.
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function(plugin)
    if vim.fn.executable("npx") == 1 then
      -- Run synchronously so lazy.nvim surfaces failures instead of a silent
      -- fire-and-forget `!` shell; that failure mode leaves app/node_modules
      -- empty and :MarkdownPreview then exits without opening a browser.
      local cmd = { "npx", "--yes", "yarn", "install" }
      local out = vim.fn.system({ "sh", "-c", "cd " .. vim.fn.shellescape(plugin.dir .. "/app") .. " && " .. table.concat(cmd, " ") })
      if vim.v.shell_error ~= 0 then
        error("markdown-preview build failed:\n" .. out)
      end
    else
      vim.cmd([[Lazy load markdown-preview.nvim]])
      vim.fn["mkdp#util#install"]()
    end
  end,
  init = function()
    if vim.fn.executable("npx") == 1 then vim.g.mkdp_filetypes = { "markdown" } end
  end,
}
