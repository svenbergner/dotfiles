-- Plugin that adds a neat file tree
-- URL: https://github.com/nvim-neo-tree/neo-tree.nvim

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
   config = function()
      vim.keymap.set("n", "<leader><leader>n", ":Neotree filesystem reveal left<CR>:Neotree focus filesystem<CR>",
         { silent = true, desc = "Show Neo-tree Filesystem" })
      vim.keymap.set("n", "<leader>nn", ":Neotree filesystem reveal left<CR>:Neotree focus filesystem<CR>",
         { silent = true, desc = "Show Neotree Filesystem" })
      vim.keymap.set("n", "<leader>nf", ":Neotree filesystem reveal left<CR>:Neotree focus filesystem<CR>",
         { silent = true, desc = "Show Neotree Filesystem" })
      vim.keymap.set("n", "<leader>nb", ":Neotree buffers reveal left<CR>:Neotree focus buffers<CR>",
         { silent = true, desc = "Show Neo-tree Buffers" })
      vim.keymap.set("n", "<leader>ng", ":Neotree git_status reveal left<CR>:Neotree focus git_status<CR>",
         { silent = true, desc = "Show Neo-tree Git Status" })
      vim.keymap.set("n", "<leader>nc", ":Neotree close<CR>",
         { silent = true, desc = "Close Neo-tree" })

      local highlights = require("neo-tree.ui.highlights")

      local function file_contains(filename, pattern)
         local current_file = filename
         if not vim.fn.filereadable(current_file) then
            return false
         end
         -- local file_content = vim.fn.readfile(current_file)
         -- for _, line in ipairs(file_content) do
         --    if line:match(pattern) then
         --       return true
         --    end
         -- end
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
               icon = function(config, node, state)
                  local icon = config.default or " "
                  local padding = config.padding or " "
                  local highlight = config.highlight or highlights.FILE_ICON
                  local plugin_state = ""

                  if node.type == "directory" then
                     highlight = highlights.DIRECTORY_ICON
                     if node:is_expanded() then
                        icon = config.folder_open or "-"
                     else
                        icon = config.folder_closed or "+"
                     end
                  elseif node.type == "file" then
                     if node.ext == "lua" then
                        if is_plugin_enabled(node.name) then
                           plugin_state = ""
                        elseif is_plugin_disabled(node.name) then
                           plugin_state = ""
                        end
                     end
                     local success, web_devicons = pcall(require, "nvim-web-devicons")
                     if success then
                        local devicon, hl = web_devicons.get_icon(node.name, node.ext)
                        icon = devicon or icon
                        highlight = hl or highlight
                     end
                  end

                  return {
                     text = icon .. padding .. plugin_state,
                     highlight = highlight,
                  }
               end,
            },
         },
      })
   end,
}
