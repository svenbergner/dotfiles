--[===[
Plugin that adds a neat file tree
URL: https://github.com/nvim-neo-tree/neo-tree.nvim
--]===]

return {
   "nvim-neo-tree/neo-tree.nvim",
   branch = "v3.x",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
      {
         "s1n7ax/nvim-window-picker",
         config = function()
            require("window-picker").setup({
               filter_rules = {
                  include_current_win = false,
                  autoselect_one = true,
                  bo = {
                     filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                     buftype = { 'terminal', 'quickfix' },
                  },
               },
            })
         end
      },
   },
   opts = function(_, opts)
      local function on_move(data)
         Snacks.rename.on_rename_file(data.source, data.destination)
      end
      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
         { event = events.FILE_MOVED,   handler = on_move },
         { event = events.FILE_RENAMED, handler = on_move },
      })
   end,
   config = function()
      vim.keymap.set("n", "<leader>nn", ":Neotree filesystem reveal left<CR>:Neotree focus filesystem<CR>",
         { silent = true, desc = "[n]eotree filesystem" })
      vim.keymap.set("n", "<leader>nf", ":Neotree filesystem reveal left<CR>:Neotree focus filesystem<CR>",
         { silent = true, desc = "[n]eotree [f]ilesystem" })
      vim.keymap.set("n", "<leader>nb", ":Neotree buffers reveal left<CR>:Neotree focus buffers<CR>",
         { silent = true, desc = "[n]eotree [b]uffers" })
      vim.keymap.set("n", "<leader>ng", ":Neotree git_status reveal left<CR>:Neotree focus git_status<CR>",
         { silent = true, desc = "[n]eotree [g]it status" })
      vim.keymap.set("n", "<leader>nc", ":Neotree close<CR>",
         { silent = true, desc = "[n]eotree [c]lose " })

      local highlights = require("neo-tree.ui.highlights")

      local function file_contains(filename, pattern)
         local current_file = filename
         if not vim.fn.filereadable(current_file) then
            return false
         end
         local file_content = vim.fn.readfile(current_file)
         for _, line in ipairs(file_content) do
            if line:match(pattern) then
               return true
            end
         end
         return false
      end

      local function is_plugin_disabled(filename)
         return file_contains(filename, "enabled%s*=%s*false")
      end

      local function is_plugin_enabled(filename)
         return file_contains(filename, "enabled%s*=%s*true")
      end

      require("neo-tree").setup({
         sources = {
            "filesystem",
            "buffers",
            "git_status",
         },
         popup_border_style = "rounded",
         close_if_last_window = false,
         auto_clean_after_session_restore = true,
         default_source = "filesystem",
         enable_git_status = true,
         enable_diagnostics = true,
         open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
         use_libuv_file_watcher = true,
         source_selector = {
            winbar = true,
            status_line = true,
            sources = {
               { source = "filesystem" },
               { source = "buffers" },
               { source = "git_status" },
            },
         },
         git_status = {
            follow_current_file = true,
         },
         buffers = {
            follow_current_file = { enabled = true, },
            group_empty_dirs = true,
            show_unloaded = true,
         },
         filesystem = {
            follow_current_file = { enabled = true, },
            filtered_items = {
               hide_dotfiles = false,
               hide_gitignored = false,
               never_show = {
                  ".DS_Store",
                  "thumbs.db"
               },
               always_show = {
                  ".env",
               }
            },
            components = {
               plugin_state = function(config, node)
                  local padding = config.padding or " "
                  local highlight = config.highlight or highlights.FILE_NAME
                  local plugin_state = ""
                  if node.type == "file" and node.ext == "lua" then
                     local plugin_enabled = is_plugin_enabled(node.path)
                     local plugin_disabled = is_plugin_disabled(node.path)
                     if plugin_enabled and plugin_disabled then
                        plugin_state = "±"
                        highlight = highlights.GIT_MODIFIED
                     elseif plugin_enabled then
                        plugin_state = ""
                        highlight = highlights.GIT_ADDED
                     elseif plugin_disabled then
                        plugin_state = ""
                        highlight = highlights.GIT_DELETED
                     end
                  end
                  return {
                     text = padding .. plugin_state,
                     highlight = highlight,
                  }
               end,
            },
            renderers = {
               file = {
                  { "indent" },
                  { "icon" },
                  {
                     "container",
                     content = {
                        {
                           "name",
                           zindex = 10
                        },
                        {
                           "symlink_target",
                           zindex = 10,
                           highlight = "NeoTreeSymbolicLinkTarget",
                        },
                        { "clipboard",     zindex = 10 },
                        { "bufnr",         zindex = 10 },
                        { "modified",      zindex = 20, align = "right" },
                        { "diagnostics",   zindex = 20, align = "right" },
                        { "git_status",    zindex = 10, align = "right" },
                        { "plugin_state",  zindex = 10, align = "right" },
                        { "file_size",     zindex = 10, align = "right" },
                        { "type",          zindex = 10, align = "right" },
                        { "last_modified", zindex = 10, align = "right" },
                        { "created",       zindex = 10, align = "right" },
                     },
                  },
               },
            },
         },
      })
   end,
}
