--[===[
Snacks.nvim: A collection of small QoL plugins for Neovim.
URL: https://github.com/folke/snacks.nvim
--]===]

return {
   "folke/snacks.nvim",
   priority = 1000,
   lazy = false,
   ---@class snacks.Config
   opts = {
      bigfile = { enabled = true, },
      bufdelete = { enabled = true, },
      dim = { enabled = true, },
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
            hl = "SnacksIndentBlank", ---@type string | string[] hl group for blank spaces
         },
      },
      input = { enabled = true, },
      lazygit = { enabled = true, },
      notify = { enabled = true, },
      notifier = { enabled = true, },
      picker = {
         enabled = true,
         layout = {
            preset = "telescope",
            reverse = false,
         },
      },
      quickfile = { enabled = true, },
      rename = { enabled = true, },
      scroll = { enabled = true, },
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
      terminal = { enabled = true, },
      toggle = { enabled = true, },
      words = { enabled = true, },
      zen = { enabled = true, },
   },

   keys = {
      { "<leader>/",  function() Snacks.picker.lines() end,          desc = "[/] Fuzzily search in current buffer" },
      { "<leader>.",  function() Snacks.scratch() end,               desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end,        desc = "Select Scratch Buffer" },
      { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end,             desc = "Delete Buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end,    desc = "Rename File" },
      { "<leader>gB", function() Snacks.gitbrowse() end,             desc = "Git Browse" },
      { "<leader>Gb", function() Snacks.git_branches() end,          desc = "[G]it [b]ranches" },
      { "<leader>gb", function() Snacks.git.blame_line() end,        desc = "Git Blame Line" },
      { "<leader>gF", function() Snacks.lazygit.log_file() end,      desc = "Lazygit Current File History" },
      { "<leader>gl", function() Snacks.lazygit.log() end,           desc = "Lazygit Log (cwd)" },
      { "<leader>sj", function() Snacks.notifier.jumps() end,        desc = "[s]how [j]umps" },
      { "<leader>su", function() Snacks.notifier.undo() end,         desc = "[s]how [u]ndo history" },
      { "<leader>un", function() Snacks.notifier.hide() end,         desc = "Dismiss All Notifications" },
      { "<leader>zm", function() Snacks.toggle.zen() end,            desc = "Toggle Zen Mode" },
      { "<leader>fa", function() Snacks.picker.autocmds() end,       desc = "[f]ind [a]utocommands" },
      { "<leader>fb", function() Snacks.picker.buffers() end,        desc = "[f]ind [b]uffers" },
      { "<leader>fB", function() Snacks.picker.grep_buffers() end,   desc = "[f]ind [g]rep in open buffers" },
      { "<leader>ff", function() Snacks.picker.files() end,          desc = "[f]ind [f]iles" },
      { "<leader>fg", function() Snacks.picker.grep() end,           desc = "[f]ind [g]rep" },
      { "<leader>fh", function() Snacks.picker.help() end,           desc = "[f]ind [h]elp" },
      { "<leader>fk", function() Snacks.picker.keymaps() end,        desc = "[f]ind [k]eymaps" },
      { "<leader>fl", function() Snacks.picker.lazy() end,           desc = "[f]ind [l]azy plugins specs" },
      { "<leader>fo", function() Snacks.picker.recent() end,         desc = "[f]ind [o]ld files" },
      { "<leader>fr", function() Snacks.picker.resume() end,         desc = "[f]ind [r]esume last search" },
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end,    desc = "[f]ind [s]ymbols" },
      { "<leader>ft", function() Snacks.picker.todo_comments() end,  desc = "[f]ind [t]odos" },
      { "<leader>fw", function() Snacks.picker.grep_word() end,      desc = "[f]ind [w]ord under cursor" },
      { "<leader>fz", function() Snacks.picker.zoxide() end,         desc = "[f]ind [z]oxide" },
      {
         "<leader>gg",
         function()
            vim.cmd("wa")
            Snacks.lazygit()
         end,
         desc = "Lazygit"
      },
      {
         "<leader><leader>g",
         function()
            vim.cmd("wa")
            Snacks.lazygit()
         end,
         desc = "Lazygit"
      },
      { "gn", function() Snacks.words.jump(vim.v.count1, true) end,  desc = "Next Reference", mode = { "n", "t" } },
      { "gp", function() Snacks.words.jump(-vim.v.count1, true) end, desc = "Prev Reference", mode = { "n", "t" } },
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
      },
      -- LSP
      { "gD",         function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
      { "gd",         function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
      { "gi",         function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
      { "gr",         function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
      { "gy",         function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
      { "<leader>Ws", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      { "<leader>gs", function() Snacks.picker.git_status() end,            desc = "[g]it [s]tatus" },
   },
}
