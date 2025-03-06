--[===[
Markdown Preview for (Neo)vim
Preview Markdown in your modern browser with synchronised scrolling and flexible configuration.

Main features:

- Cross platform (MacOS/Linux/Windows)
- Synchronised scrolling
- Fast asynchronous updates
- KaTeX for typesetting of math
- PlantUML
- Mermaid
- Chart.js
- js-sequence-diagrams
- Flowchart
- dot
- Table of contents
- Emojis
- Task lists
- Local images
- Flexible configuration

NOTE: the plugin mathjax-support-for-mkdp is not needed for typesetting math.

URL: https://github.com/iamcco/markdown-preview.nvim 
--]===]

-- install without yarn or npm
return {
  "iamcco/markdown-preview.nvim",
  enabled = true,
  event = 'VeryLazy',
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install"]() end,
}

-- install with yarn or npm
-- {
--   "iamcco/markdown-preview.nvim",
--   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--   build = "cd app && yarn install",
--   init = function()
--     vim.g.mkdp_filetypes = { "markdown" }
--   end,
--   ft = { "markdown" },
-- },
