return {
   "vim-test/vim-test",
   config = function ()
      vim.keymap.set("n","<leader>t", function() vim.cmd('TestNearest') end );
   end
}
