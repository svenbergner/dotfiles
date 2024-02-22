return {
   "vim-test/vim-test",
   config = function()
      vim.keymap.set("n", "<leader>tn", function() vim.cmd('TestNearest') end,
         { desc = 'Run [t]est [n]earest' });
   end
}
