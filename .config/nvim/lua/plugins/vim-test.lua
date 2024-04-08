return {
   "vim-test/vim-test",
   dependencies = {
      "preservim/vimux"
   },
   config = function()
      -- vim.keymap.set("n", "<leader>t", function() vim.cmd('TestNearest') end, { desc = 'Run nearest [t]est' });
      -- vim.keymap.set("n", "<leader>T", function() vim.cmd('TestFile') end, { desc = 'Run all [T]ests in file' });
      -- vim.keymap.set("n", "<leader>a", function() vim.cmd('TestSuite') end, { desc = 'Run [a]ll [t]ests in suite' });
      -- vim.keymap.set("n", "<leader>l", function() vim.cmd('TestLast') end, { desc = 'Run [l]ast test' });
      -- vim.keymap.set("n", "<leader>g", function() vim.cmd('TestVisit') end, { desc = '[g]oto last test' });
      vim.cmd("let test#strategy = 'vimux'")
   end
}
