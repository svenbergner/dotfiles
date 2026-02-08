--[===[
Plugin to generate source code screenshots
URL: https://github.com/michaelrommel/nvim-silicon
--]===]

return {
   'michaelrommel/nvim-silicon',
   enabled = true,
   lazy = true,
   cmd = 'Silicon',
   config = function()
      require('silicon').setup({
         font = 'JetBrainsMono Nerd Font=34;Noto Color Emoji=34',
         theme = 'gruvbox-dark',
         background = '#d4c4a3',
         window_title = function()
            return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ':t')
         end,
      })
   end,
}
