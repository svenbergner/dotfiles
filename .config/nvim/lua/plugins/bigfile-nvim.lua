-- Helps to open really big files
return {
   'LunarVim/bigfile.nvim',
   event = 'BufReadPre',
   config = function()
      require('bigfile').setup({
         filesize = 2, -- Plugin gets startet with 2 MB filesize
      })
   end
}
