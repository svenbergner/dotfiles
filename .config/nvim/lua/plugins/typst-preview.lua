--[===[
Typst Preview for Neovim

💪 Features
- Low latency preview: preview your document instantly on type. The
incremental rendering technique makes the preview latency as low as possible.
- Cross jump between code and preview. You can click on the preview to jump to the
corresponding code location and have the preview follow your cursor in Neovim.

URL: https://github.com/chomosuke/typst-preview.nvim
--]===]

return {
   'chomosuke/typst-preview.nvim',
   enabled = true,
   lazy = false, -- or ft = 'typst'
   version = '1.*',
   opts = {},    -- lazy.nvim will implicitly calls `setup {}`
}
