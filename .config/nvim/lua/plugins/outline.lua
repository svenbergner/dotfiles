--[===[
Shows an outline view for the current buffer
https://github.com/hedyhli/outline.nvim
--]===]

return {
   'hedyhli/outline.nvim',
   enabled = true,
   lazy = true,
   cmd = { 'Outline', 'OutlineOpen' },
   keys = {
      { '<leader>To', '<cmd>Outline<CR>', desc = '[T]oggle [o]utline' },
   },
   opts = {},
}
