--[====[
install without yarn or npm
URL: https://www.github.com/iamcco/markdown-preview.nvim 
--]====]

return {
  "iamcco/markdown-preview.nvim",
  enabled = true,
  event = 'VeryLazy',
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
}

-- -- install with yarn or npm
-- {
--   "iamcco/markdown-preview.nvim",
--   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--   build = "cd app && yarn install",
--   init = function()
--     vim.g.mkdp_filetypes = { "markdown" }
--   end,
--   ft = { "markdown" },
-- },
