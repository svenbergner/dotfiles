--[===[
Live Preview for Neovim
https://github.com/brianhuster/live-preview.nvim

This is a plugin for Neovim that allows you to view Markdown,
HTML (along with CSS, JavaScript), AsciiDoc and SVG files in a web browser
with live updates. No external dependencies or runtime like NodeJS or Python
are required, since the backend is fully written in Lua and Neovim's built-in functions.

Features ✨
- Preview Markdown, AsciiDoc, SVG with live updates as you type
- Preview HTML (with CSS and JavaScript) with live updates as you save the file
- Supports KaTeX and Mermaid for rendering math equations and diagrams in Markdown and AsciiDoc files
- Syntax highlighting for code blocks in Markdown and AsciiDoc 🖍️
- Supports sync scrolling in the browser as you scroll in the Markdown files in Neovim.
- Integration with telescope.nvim 🔭, fzf-lua and mini.pick
--]===]

return {
   'brianhuster/live-preview.nvim',
   enabled = true,
   cmd = { 'LivePreview' },
   dependencies = {
      'nvim-telescope/telescope.nvim',
   },
}
