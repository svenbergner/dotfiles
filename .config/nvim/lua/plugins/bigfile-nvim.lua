-- Helps to open really big files by disabling resource hungry features
return {
   'LunarVim/bigfile.nvim',
   enabled = false,
   event = 'BufReadPre',
   config = function()
      require('bigfile').setup({
         filesize = 2, -- Plugin gets startet with 2 MB filesize
      })
   end
}
