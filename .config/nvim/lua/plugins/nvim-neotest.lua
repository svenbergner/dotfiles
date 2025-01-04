-- Flutter Test support
-- See :h neotest.run.run() for parameters.
-- https://github.com/nvim-neotest/neotest
return {
   "nvim-neotest/neotest",
   dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "sidlatau/neotest-dart",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
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
            require('neotest-python') {
               runner = "pytest",
               python = "python",
               use_lsp = true,
            },
            require('neotest-plenary') {},
         }
      })

      vim.keymap.set("n", "<leader>tn", function()
         vim.cmd('wa')
         neotest.run.run()
      end, { desc = '[t]est: run [n]earest' });

      vim.keymap.set("n", "<leader>ts", function()
         neotest.run.stop()
      end, { desc = '[t]est: [s]top running test' });

      vim.keymap.set("n", "<leader>ta", function()
         vim.cmd('wa')
         neotest.run.run(vim.fn.expand("%"))
      end, { desc = '[T]ests run [a]ll in file' });

      vim.keymap.set("n", "<leader>td", function()
         neotest.run.run({ strategy = "dap" })
      end, { desc = '[d]ebug nearest [t]est' });

      vim.keymap.set("n", "<leader>tr", function()
         neotest.output.open({ enter = true, quiet = true, auto_close = true, last_run = true })
      end, { desc = 'Show [t]est [r]esults' });

      vim.keymap.set("n", "<leader>tst", function()
         neotest.summary.toggle()
      end, { desc = '[t]est [s]ummary [t]oggle' });
   end,
}
