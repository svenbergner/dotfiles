--[===[
Typst Preview for Neovim
https://github.com/chomosuke/typst-preview.nvim

💪 Features
- Low latency preview: preview your document instantly on type. The
incremental rendering technique makes the preview latency as low as possible.
- Cross jump between code and preview. You can click on the preview to jump to the
corresponding code location and have the preview follow your cursor in Neovim.
--]===]

return {
   'chomosuke/typst-preview.nvim',
   enabled = true,
   ft = 'typst',
   version = '1.*',
   opts = {}, -- lazy.nvim will implicitly calls `setup {}`
}
