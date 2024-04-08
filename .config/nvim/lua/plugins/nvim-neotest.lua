-- Flutter Test support
-- See :h neotest.run.run() for parameters.
return {
   "nvim-neotest/neotest",
   dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "sidlatau/neotest-dart",
   },
   config = function()
      local neotest = require('neotest')
      neotest.setup({
         adapters = {
            require('neotest-dart') {
               command = "fvm flutter",
               use_lsp = true,
               -- Useful when using custom test names with @isTest annotation
               custom_test_method_names = {},
            },
         }
      })
      vim.keymap.set("n", "<leader>t", function() neotest.run.run() end, { desc = 'Run nearest [t]est' });
      -- Attach to the nearest test, see :h neotest.run.attach()
      vim.keymap.set("n", "<leader>ta", function() neotest.run.run() end, { desc = 'Nearest [t]est [a]ttach' });
      -- Stop the nearest test, see :h neotest.run.stop()
      vim.keymap.set("n", "<leader>ts", function() neotest.run.stop() end, { desc = 'Nearest [t]est [s]top' });
      vim.keymap.set("n", "<leader>T", function() neotest.run.run(vim.fn.expand("%")) end,
         { desc = 'Run all [T]ests in file' });
      -- Debug the nearest test (requires nvim-dap and adapter support)
      vim.keymap.set("n", "<leader>dt", function() neotest.run.run({ strategy = "dap" }) end,
         { desc = '[d]ebug nearest [t]est' });
      vim.keymap.set("n", "<leader>t", function() neotest.run.run() end, { desc = 'Run nearest [t]est' });
      -- vim.keymap.set("n", "<leader>a", function()  end, { desc = 'Run [a]ll [t]ests in suite' });
      -- vim.keymap.set("n", "<leader>l", function()  end, { desc = 'Run [l]ast test' });
      -- vim.keymap.set("n", "<leader>g", function()  end, { desc = '[g]oto last test' });
   end,
}
