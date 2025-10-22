--[===[
Tinymist Neovim Support for Typst

Run and configure tinymist in Neovim with support for all major distros and
package managers.

Feature Integration Language service (completion, definitions, etc.) Code
Formatting Live Web Preview with typst-preview. Work for full parity for all
tinymist features is underway. This will include: exporting to different file
types, template preview, and multifile support. Neovim integration is behind VS
Code currently but should be caught up in the near future.

URL: https://myriad-dreamin.github.io/tinymist/frontend/neovim.html
--]===]

return {
   cmd = { "tinymist" },
   filetypes = { "typst" },
   settings = {
      formatterMode = "typstyle",
      exportPdf = "onType",
      semanticTokens = "disable"
   }
}
