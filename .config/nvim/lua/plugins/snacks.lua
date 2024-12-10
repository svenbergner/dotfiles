--[=====[
A collection of small QoL plugins for Neovim.
https://github.com/folke/snacks.nvim
--]=====]
return {
   "folke/snacks.nvim",
   priority = 1000,
   lazy = false,
   ---@type snacks.Config
   opts = {
      bigfile = { enabled = true, },
      bufdelete = { enabled = true, },
      git = { enabled = true, },
      gitbrowse = { enabled = true, },
      indent = {
         enabled = true,
         indent = {
            char = "▎",
            blank = "·",
            hl = {
               "SnacksIndent1",
               "SnacksIndent2",
               "SnacksIndent3",
               "SnacksIndent4",
               "SnacksIndent5",
               "SnacksIndent6",
               "SnacksIndent7",
               "SnacksIndent8",
            },
         },
         scope = {
            char = "▎",
         },
         blank = {
            char = "·",
            hl = "SnacksIndentBlank", ---@type string|string[] hl group for blank spaces
         },
      },
      lazygit = { enabled = true, },
      notify = { enabled = true, },
      notifier = { enabled = true, },
      quickfile = { enabled = true, },
      statuscolumn = {
         enabled = true,
         left = { "mark", "sign" }, -- priority of signs on the left (high to low)
         right = { "fold", "git" }, -- priority of signs on the right (high to low)
         folds = {
            open = true,            -- show open fold icons
            git_hl = true,          -- use Git Signs hl for fold icons
         },
         git = {
            -- patterns to match Git signs
            patterns = { "GitSign", "MiniDiffSign" },
         },
         refresh = 50, -- refresh at most every 50ms
      },
      toggle = { enabled = true, },
      words = { enabled = true, },
      zen = { enabled = true, },
   },

   keys = {
      { "<leader>.",         function() Snacks.scratch() end,                 desc = "Toggle Scratch Buffer" },
      { "<leader>S",         function() Snacks.scratch.select() end,          desc = "Select Scratch Buffer" },
      { "<leader>n",         function() Snacks.notifier.show_history() end,   desc = "Notification History" },
      { "<leader>bd",        function() Snacks.bufdelete() end,               desc = "Delete Buffer" },
      { "<leader>cR",        function() Snacks.rename.rename_file() end,      desc = "Rename File" },
      { "<leader>gB",        function() Snacks.gitbrowse() end,               desc = "Git Browse" },
      { "<leader>gb",        function() Snacks.git.blame_line() end,          desc = "Git Blame Line" },
      { "<leader>gF",        function() Snacks.lazygit.log_file() end,        desc = "Lazygit Current File History" },
      { "<leader>gg",        function() Snacks.lazygit() end,                 desc = "Lazygit" },
      { "<leader><leader>g", function() Snacks.lazygit() end,                 desc = "Lazygit" },
      { "<leader>gl",        function() Snacks.lazygit.log() end,             desc = "Lazygit Log (cwd)" },
      { "<leader>un",        function() Snacks.notifier.hide() end,           desc = "Dismiss All Notifications" },
      { "<leader>zm",        function() Snacks.zen() end,                     desc = "Toggle Zen Mode" },
      -- { "<c-/>",             function() Snacks.toggle() end,                  desc = "Toggle Snacks" },
      -- { "<c-/>",             function() Snacks.terminal() end,                desc = "Toggle Terminal" },
      -- { "<c-_>",             function() Snacks.terminal() end,                desc = "which_key_ignore" },
      { "]]",                function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",              mode = { "n", "t" } },
      { "[[",                function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",              mode = { "n", "t" } },
      {
         "<leader>N",
         desc = "Neovim News",
         function()
            Snacks.win({
               file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
               width = 0.6,
               height = 0.6,
               wo = {
                  spell = false,
                  wrap = false,
                  signcolumn = "yes",
                  statuscolumn = " ",
                  conceallevel = 3,
               },
            })
         end,
      }
   },
}
