--[===[
Snacks.nvim: A collection of small QoL plugins for Neovim.
URL: https://github.com/folke/snacks.nvim
--]===]

local file_opts = {
   hidden = true,
}

local config_path = {
   cwd = vim.fn.expand("$HOME") .. "/Repos/dotfiles/.config/nvim"
}

local help_opts = {
   win = {
      input = {
         keys = {
            ["<return>"] = {
               "edit_vsplit",
               desc = "Edit Vsplit",
               mode = { "n", "i" },
            },
         },
      },
   },
}

local marks_opts = {
   finder = "vim_marks",
   format = "file",
   global = true,
   ["local"] = true,
}

local noice_opts = {
   supports_live = true,
}

local zen_opts = {
   enter = true,
   fixbuf = false,
   minimal = false,
   width = 260,
   height = 0,
   backdrop = { transparent = false, blend = 1 },
   keys = { q = false },
   zindex = 40,
   wo = {
      winhighlight = "NormalFloat:Normal",
   },
   w = {
      snacks_main = true,
   },
}

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
      image = { enabled = true, },
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
         win = {
            input = {
               keys = {
                  ["<a-s>"] = { "flash", mode = { "n", "i" }, },
                  ["<s>"] = { "flash" },
               },
            },
         },
         actions = {
            flash = function(picker)
               require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                     mode = "search",
                     exclude = {
                        function(win)
                           return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                        end,
                     },
                  },
                  action = function(match)
                     local idx = picker.list:row2idx(match.pos[1])
                     picker.list:_move(idx, true, true)
                  end,
               })
            end,
         },
         layout = {
            preset = "telescope",
            reverse = false,
         },
         matcher = {
            frecency = true,
         },
      },
      quickfile = { enabled = true, },
      rename = { enabled = true, },
      scope = { enabled = true, },
      scroll = { enabled = true, },
      statuscolumn = {
         enabled = true,
         left = { "mark", "sign" }, -- Priority of signs on the left (high to low)
         right = { "fold", "git" }, -- Priority of signs on the right (high to low)
         folds = {
            open = true,            -- show open fold icons
            git_hl = true,          -- Use Git Signs hl for fold icons
         },
         git = {
            -- patterns to match Git signs
            patterns = { "GitSign", "MiniDiffSign" },
         },
         refresh = 50, -- refresh at most every 50 milliseconds
      },
      terminal = { enabled = true, },
      toggle = { enabled = true, },
      words = { enabled = true, },
      zen = { enabled = true, },
   },

   keys = {
      { "<leader>.",  function() Snacks.scratch() end,                   desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end,            desc = "[S]elect Scratch Buffer" },
      { "<leader>n",  function() Snacks.notifier.show_history() end,     desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end,                 desc = "Delete Buffer" },
      { "<leader>:",  function() Snacks.picker.command_history() end,    desc = "[p] Show command history" },
      { "<leader>h",  function() Snacks.notifier.hide() end,             desc = "[h]ide all notifications" },
      { "<leader>zm", function() Snacks.zen(zen_opts) end,               desc = "Toggle [z]en [m]ode" },
      { "<leader>zz", function() Snacks.zen.zoom() end,                  desc = "[z]oom [z]en" },
      -- Picker
      { "<leader>fp", function() Snacks.picker.pickers() end,            desc = "[f]ind [p]ickers" },
      { "<leader>fa", function() Snacks.picker.autocmds() end,           desc = "[f]ind [a]utocommands" },
      { "<leader>fb", function() Snacks.picker.buffers() end,            desc = "[f]ind [b]uffers" },
      { "<leader>fB", function() Snacks.picker.grep_buffers() end,       desc = "[f]ind [g]rep in open buffers" },
      { "<leader>fc", function() Snacks.picker.files(config_path) end,   desc = "[f]ind [c]onfig files" },
      { "<leader>fC", function() Snacks.picker.colorschemes() end,       desc = "[f]ind [C]olorschemes" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end,        desc = "[f]ind [d]iagnostics" },
      { '<leader>fD', function() Snacks.picker.diagnostics_buffer() end, desc = '[f]ind all [d]iagnostics of git repo', },
      { "<leader>fe", function() Snacks.picker.explorer() end,           desc = "[f]ind [e]xplorer" },
      { "<leader>ff", function() Snacks.picker.files(file_opts) end,     desc = "[f]ind [f]iles" },
      { "<leader>fF", function() Snacks.picker.smart() end,              desc = "[f]ind [F]iles smart" },
      { "<leader>fg", function() Snacks.picker.grep(file_opts) end,      desc = "[f]ind [g]rep" },
      { "<leader>fw", function() Snacks.picker.grep_word(file_opts) end, desc = "[f]ind [w]ord under cursor" },
      { "<leader>fh", function() Snacks.picker.help(help_opts) end,      desc = "[f]ind [h]elp" },
      { "<leader>fH", function() Snacks.picker.highlights() end,         desc = "[f]ind [H]ighlights" },
      { "<leader>fj", function() Snacks.picker.jumps() end,              desc = "[f]ind [j]umps" },
      { "<leader>fk", function() Snacks.picker.keymaps() end,            desc = "[f]ind [k]eymaps" },
      { "<leader>fl", function() Snacks.picker.lazy() end,               desc = "[f]ind [l]azy plugins specs" },
      { "<leader>/",  function() Snacks.picker.lines() end,              desc = "[/] fuzzy search in buffer" },
      { "<leader>fm", function() Snacks.picker.marks(marks_opts) end,    desc = "[f]ind [m]arks" },
      { "<leader>fn", function() Snacks.picker.noice(noice_opts) end,    desc = "[f]ind [n]oice messages" },
      { "<leader>fo", function() Snacks.picker.recent() end,             desc = "[f]ind [o]ld files" },
      { "<leader>fr", function() Snacks.picker.resume() end,             desc = "[f]ind [r]esume last search" },
      { "<leader>fR", function() Snacks.picker.registers() end,          desc = "[f]ind [r]egisters" },
      { "<leader>ft", function() Snacks.picker.todo_comments() end,      desc = "[f]ind [t]odos" },
      { "<leader>fT", function() Snacks.picker.treesitter() end,         desc = "[f]ind [T]reesitter" },
      { "<leader>fu", function() Snacks.picker.undo() end,               desc = "[f]ind [u]ndo history" },
      { "<leader>fz", function() Snacks.picker.zoxide() end,             desc = "[f]ind [z]oxide" },
      { "<leader>fi", function() Snacks.picker.icons() end,              desc = "[f]ind [i]cons" },
      { "<leader>z=", function() Snacks.picker.spelling() end,           desc = "Show spellings" },
      -- lazygit
      {
         "<leader>gg",
         function()
            vim.cmd("wa")
            Snacks.lazygit()
         end,
         desc = "Lazygit"
      },
      -- Show latest Neovim News
      {
         "<leader>NN",
         desc = "[N]eovim [N]ews",
         function()
            local neovim_news = Snacks.win({
               file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
               width = 100,
               height = 0.8,
               border = 'rounded',
               wo = {
                  spell = false,
                  wrap = false,
                  signcolumn = "yes",
                  statuscolumn = " ",
                  conceallevel = 3,
               },
            })
            neovim_news:set_title("Neovim News", "center")
         end,
      },
      -- LSP
      { "gC",         function() Snacks.picker.lsp_config() end,            desc = "LSP: [g]oto [C]onfig" },
      { "gD",         function() Snacks.picker.lsp_declarations() end,      desc = "LSP: [g]oto [D]eclaration" },
      { "gd",         function() Snacks.picker.lsp_definitions() end,       desc = "LSP: [g]oto [d]efinition" },
      { "gi",         function() Snacks.picker.lsp_implementations() end,   desc = "LSP: [G]oto [i]mplementation" },
      { "gr",         function() Snacks.picker.lsp_references() end,        desc = "LSP: [g]oto [r]eferences",             nowait = true },
      { "gt",         function() Snacks.picker.lsp_type_definitions() end,  desc = "LSP: [g]oto [t]ype Definition" },
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end,           desc = "LSP: [f]ind [s]ymbols in current file" },
      { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP: [f]ind [S]ymbols in workspace " },
      -- git
      { "<leader>gB", function() Snacks.picker.git_branches() end,          desc = "show [g]it [B]ranches" },
      { "<leader>gx", function() Snacks.gitbrowse() end,                    desc = "open [g]it repo in e[x]tern Browser" },
      { "<leader>gF", function() Snacks.lazygit.log_file() end,             desc = "lazy[g]it Current [F]ile log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end,          desc = "[g]it [L]og current line" },
      { "<leader>gS", function() Snacks.picker.git_stash() end,             desc = "[g]it [S]tash" },
      { "<leader>gb", function() Snacks.git.blame_line() end,               desc = "[g]it [b]lame line" },
      { "<leader>gd", function() Snacks.picker.git_diff() end,              desc = "[g]it [d]iff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end,          desc = "[g]it log [f]ile" },
      { "<leader>gl", function() Snacks.lazygit.log() end,                  desc = "lazy[g]it [l]og (cwd)" },
      { "<leader>gs", function() Snacks.picker.git_status() end,            desc = "[g]it [s]tatus" },
      { '<leader>gC', function() Snacks.picker.git_log() end,               desc = "search all [g]it [C]ommits" },
      { '<leader>gc', function() Snacks.picker.git_log_file() end,          desc = "search [g]it [c]ommits for Buffer" },
   },
   init = function()
      vim.api.nvim_create_autocmd("User", {
         pattern = "VeryLazy",
         callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...)
               Snacks.debug.inspect(...)
            end
            _G.bt = function()
               Snacks.debug.backtrace()
            end
            vim.print = _G.dd -- Override print to use snacks for `:=` command

            -- Create some toggle mappings
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>Ts")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>Tw")
            Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>Tl")
            Snacks.toggle.diagnostics():map("<leader>Td")
            Snacks.toggle.line_number():map("<leader>TL")
            Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                :map("<leader>Tc")
            Snacks.toggle.treesitter():map("<leader>TT")
            Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
               "<leader>Tb")
            Snacks.toggle.inlay_hints():map("<leader>Th")
            Snacks.toggle.indent():map("<leader>Tg")
            Snacks.toggle.dim():map("<leader>TD")
         end,
      })
   end,
}
