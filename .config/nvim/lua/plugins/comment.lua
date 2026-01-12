--[===[
Add or remove line or block comments
URL: https://github.com/numToStr/Comment.nvim
--]===]

return {
   'numToStr/Comment.nvim',
   enabled = true,
   keys = {
      { 'gcc', mode = { 'n' } },
      { 'gbc', mode = { 'n' } },
      { 'gcO', mode = { 'n' } },
      { 'gco', mode = { 'n' } },
      { 'gcA', mode = { 'n' } },
      { 'gc', mode = { 'n', 'v' } },
      { 'gb', mode = { 'n', 'v' } },
   },
   opts = {},
}
